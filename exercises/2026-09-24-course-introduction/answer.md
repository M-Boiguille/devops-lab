# Réponse — Course Introduction

## Ce que j'ai fait (Build)

### Tâche 1 — Machine de lab Linux
- Conteneur Ubuntu 22.04 défini dans `src/Dockerfile` et orchestré par `src/docker-compose.yaml`.
- Accès SSH fonctionnel (clé `dummy_ssh_key`) pour l'utilisateur `exercise`, membre du groupe `dummy_sudo` avec **sudo sans mot de passe** :

```
user: exercise / groups: dummy_sudo
sudo: root
```

- Outils installés et vérifiés :

```
vim: VIM 8.2
git: git version 2.34.1
curl: curl 7.81.0
apt: apt 2.4.14
wget, openssh-server, ufw
```

- Permissions SSH correctes : `700` sur `~/.ssh`, `600` sur `authorized_keys`.

### Tâche 2 — Documentation du cours
- `llms.txt` téléchargé depuis `https://notes.kodekloud.com/llms.txt`.
- Page du cours LFCS récupérée dans `files/lfcs-notes/` :
  `prep-course-linux-foundation-certified-system-administrator-lfcs-certification.md`.
- Sections principales identifiées dans l'index : Essential Commands, Operations
  Deployment, Users and Groups, Networking, Storage.

### Tâche 3 — Suivi de progression versionné
- Dépôt Git initialisé dans `files/` (`lfcs-notes`) avec `README.md` contenant :
  objectif de la préparation, sections du cours, environnement, packages installés.
- Premier commit effectué.

## Pannes provoquées puis réparées (Break)

### Scénario 1 — Casser puis réparer l'accès SSH
Le script `src/ssh/chaos.sh` injecte une panne SSH puis attend la commande
`make chaos-next` avant de restaurer et de passer à la suivante.

Panne observée (`disable_pubkey`), connexion refusée :

```
[chaos] nouveau scénario: disable_pubkey
[chaos] désactivation de l'authentification par clé publique

# make ssh-test
[13:19:47] #1 déconnexion KO -> exercise@server: Permission denied (password).
[13:19:50] #2 déconnexion KO -> exercise@server: Permission denied (password).
```

Réparation via la console directe (`docker exec`) :

```
$ docker exec -u root <cid> bash -lc \
    "sed -i 's/^PubkeyAuthentication no$/PubkeyAuthentication yes/' /etc/ssh/sshd_config && pkill sshd; /usr/sbin/sshd"
repaired
```

Connexion rétablie :

```
# make ssh-test
[13:20:10] #1 connexion OK -> CONNECTED=exercise@453266dd3031
[13:20:13] #2 connexion OK -> CONNECTED=exercise@453266dd3031
Résultat: 2 connexion(s) réussie(s), 0 déconnexion(s)/échec(s)
```

### Scénario 2 — Altérer puis restaurer le suivi Git
- Ligne importante supprimée du `README.md` (`Essential Commands`) puis commitée.
- Restauration de l'état précédent avec `git revert`.

Historique Git (au moins deux commits : ajout initial + restauration) :

```
d7be803 Revert "break: remove Essential Commands line"
1154c83 break: remove Essential Commands line
0960c94 add: LFCS notes + README
```

Diff de la restauration :

```
@@ -13,6 +13,7 @@ For this LFCS preparation cycle, I'll study this areas:

+- Essential Commands
 - Operations Deployment
 - Users and Groups
 - Networking
```

## Rappel (interleaving)

1. **Conteneurs actifs + ressources** : `docker ps` liste les conteneurs actifs ;
   `docker stats` (ou `docker stats --no-stream`) affiche CPU, mémoire, réseau et I/O par conteneur.
2. **Comparer le répertoire de travail au dernier commit** : `git diff`
   (`git diff --staged` pour l'index, `git status` pour une vue d'ensemble).
3. **Disque et mémoire** : `df -h` pour l'espace disque des systèmes de fichiers,
   `free -h` pour la mémoire vive (et swap). Compléments : `du -sh`, `lsblk`.

## Difficultés / questions

- Le tir de panne est aléatoire : `make ssh-test` recharge la config compose et
  réinitialise le scénario forcé avec `chaos-scenario`. Pour observer un scénario
  précis, lire `make chaos-log` puis réparer avant de relancer un test.
- `ufw` ne fonctionne dans le conteneur qu'avec la capability `NET_ADMIN` (ajoutée
  dans `docker-compose.yaml`).
