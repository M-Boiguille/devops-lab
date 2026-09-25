#!/usr/bin/env bash
#
# Teste l'accès SSH au conteneur avec la clé factice (dummy_ssh_key).
# Le script ne modifie pas la configuration : il se contente d'observer.
# Il lance un conteneur client éphémère sur le même réseau Docker que le
# serveur, puis tente une connexion SSH à intervalles réguliers. Le serveur
# étant volontairement instable (chaos.sh), on doit observer
# alternativement des connexions réussies (connexion) et refusées (déconnexion).

set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMPOSE_FILE="$ROOT/src/docker-compose.yaml"
KEY_DIR="$ROOT/src/ssh"
KEY_NAME="dummy_ssh_key"

ATTEMPTS="${ATTEMPTS:-10}"
INTERVAL="${INTERVAL:-3}"
REMOTE_USER="${REMOTE_USER:-exercise}"
REMOTE_HOST="${REMOTE_HOST:-server}"

info()  { printf '\033[36m%s\033[0m\n' "$*"; }
ok()    { printf '\033[32m%s\033[0m\n' "$*"; }
fail()  { printf '\033[31m%s\033[0m\n' "$*"; }
warn()  { printf '\033[33m%s\033[0m\n' "$*"; }

command -v docker >/dev/null 2>&1 || { fail "docker introuvable"; exit 127; }
[ -f "$COMPOSE_FILE" ] || { fail "compose introuvable: $COMPOSE_FILE"; exit 1; }
[ -f "$KEY_DIR/$KEY_NAME" ] || { fail "clé introuvable: $KEY_DIR/$KEY_NAME"; exit 1; }

CID="$(docker compose -f "$COMPOSE_FILE" ps -q server 2>/dev/null)"
[ -n "$CID" ] || { fail "conteneur 'server' non démarré (make up)"; exit 1; }

NETWORK="$(docker inspect -f '{{range $k,$v := .NetworkSettings.Networks}}{{$k}}{{end}}' "$CID")"
IMAGE="$(docker inspect -f '{{.Config.Image}}' "$CID")"
[ -n "$NETWORK" ] || { fail "réseau Docker introuvable pour le conteneur"; exit 1; }

info "Serveur   : $CID"
info "Image     : $IMAGE"
info "Réseau    : $NETWORK"
info "Utilisateur: $REMOTE_USER@$REMOTE_HOST"
info "Tentatives: $ATTEMPTS (intervalle ${INTERVAL}s)"
echo

connect_ok=0
connect_ko=0

for i in $(seq 1 "$ATTEMPTS"); do
  ts="$(date +%H:%M:%S)"
  output="$(docker run --rm \
      --network "$NETWORK" \
      -v "$KEY_DIR:/keys:ro" \
      "$IMAGE" \
      bash -c "install -m 600 /keys/$KEY_NAME /tmp/k && \
        ssh -i /tmp/k \
            -o StrictHostKeyChecking=no \
            -o UserKnownHostsFile=/dev/null \
            -o BatchMode=yes \
            -o ConnectTimeout=4 \
            '$REMOTE_USER@$REMOTE_HOST' 'echo CONNECTED=\$(whoami)@\$(hostname)'" 2>&1)"
  rc=$?

  if [ $rc -eq 0 ]; then
    connect_ok=$((connect_ok + 1))
    ok "[$ts] #$i connexion   OK   -> $(echo "$output" | tr -d '\r' | tail -n1)"
  else
    connect_ko=$((connect_ko + 1))
    reason="$(echo "$output" | tr -d '\r' | tail -n1)"
    fail "[$ts] #$i déconnexion KO   -> $reason"
  fi

  [ "$i" -lt "$ATTEMPTS" ] && sleep "$INTERVAL"
done

echo
info "Résultat: $connect_ok connexion(s) réussie(s), $connect_ko déconnexion(s)/échec(s)"

if [ "$connect_ok" -eq 0 ]; then
  fail "Aucune connexion SSH réussie : vérifier sshd, authorized_keys et le réseau."
  exit 1
fi

if [ "$connect_ko" -eq 0 ]; then
  warn "Aucune déconnexion observée : le cycle de panne n'a pas été détecté (augmenter ATTEMPTS)."
fi

ok "Test terminé : l'accès SSH avec la clé factice fonctionne."
