#!/bin/bash
#
# chaos.sh — injecte une panne SSH choisie parmi plusieurs, puis attend une
# commande avant de restaurer l'état sain et de passer à la panne suivante.
#
# Pannes possibles :
#   stop_sshd       arrêt du service sshd
#   change_port     Port 22 -> 2222
#   disable_pubkey  PubkeyAuthentication no
#   bad_group       AllowGroups avec un groupe inexistant
#   ufw_block       pare-feu ufw bloque le port 22
#
# Utilisation :
#   CHAOS_SCENARIO=random|<nom>  (défaut: random)
#
# Pour avancer : `make chaos-next` (dépose /run/chaos/next), après avoir
# diagnostiqué et réparé à la main via `docker exec` ou `make shell`.

set -u

CONFIG="/etc/ssh/sshd_config"
STATE_DIR="/run/chaos"
TRIGGER="$STATE_DIR/next"
CHAOS_SCENARIO="${CHAOS_SCENARIO:-random}"

SCENARIOS=(stop_sshd change_port disable_pubkey bad_group ufw_block)
CURRENT=""

log() { echo "[chaos $(date +%T)] $*"; }

restart_sshd() {
  pkill sshd 2>/dev/null
  /usr/sbin/sshd
}

start_sshd() {
  mkdir -p /run/sshd
  pkill sshd 2>/dev/null
  /usr/sbin/sshd
}

apply() {
  case "$1" in
    stop_sshd)
      log "arrêt de sshd"
      pkill sshd 2>/dev/null
      ;;
    change_port)
      log "changement du port SSH: 22 -> 2222"
      sed -i 's/^#\?Port 22$/Port 2222/' "$CONFIG"
      restart_sshd
      ;;
    disable_pubkey)
      log "désactivation de l'authentification par clé publique"
      sed -i 's/^#\?PubkeyAuthentication.*/PubkeyAuthentication no/' "$CONFIG"
      restart_sshd
      ;;
    bad_group)
      log "restriction d'accès au groupe inexistant 'no_such_group'"
      echo "AllowGroups no_such_group" >>"$CONFIG"
      restart_sshd
      ;;
    ufw_block)
      log "blocage du port 22 par ufw"
      ufw --force enable >/dev/null 2>&1
      ufw deny 22/tcp >/dev/null 2>&1
      ;;
    *)
      log "scénario inconnu: $1"
      ;;
  esac
}

revert() {
  case "$1" in
    stop_sshd)
      log "redémarrage de sshd"
      restart_sshd
      ;;
    change_port)
      log "restauration du port SSH: 2222 -> 22"
      sed -i 's/^Port 2222$/Port 22/' "$CONFIG"
      restart_sshd
      ;;
    disable_pubkey)
      log "réactivation de l'authentification par clé publique"
      sed -i 's/^PubkeyAuthentication no$/PubkeyAuthentication yes/' "$CONFIG"
      restart_sshd
      ;;
    bad_group)
      log "suppression de la restriction de groupe"
      sed -i '/^AllowGroups no_such_group$/d' "$CONFIG"
      restart_sshd
      ;;
    ufw_block)
      log "ouverture du port 22 et désactivation de ufw"
      ufw allow 22/tcp >/dev/null 2>&1
      ufw --force disable >/dev/null 2>&1
      ;;
  esac
}

wait_next() {
  rm -f "$TRIGGER"
  log "panne '$CURRENT' en place — répare puis lance 'make chaos-next'"
  while [ ! -f "$TRIGGER" ]; do
    sleep 2
  done
  log "signal reçu ('make chaos-next')"
}

on_exit() {
  log "arrêt demandé — restauration de l'état sain"
  [ -n "$CURRENT" ] && revert "$CURRENT"
  exit 0
}

trap on_exit TERM INT

mkdir -p "$STATE_DIR"
start_sshd

while true; do
  if [ "$CHAOS_SCENARIO" = "random" ]; then
    CURRENT="${SCENARIOS[$((RANDOM % ${#SCENARIOS[@]}))]}"
  else
    CURRENT="$CHAOS_SCENARIO"
  fi

  log "nouveau scénario: $CURRENT"
  apply "$CURRENT"
  wait_next
  revert "$CURRENT"
  sleep 3
done
