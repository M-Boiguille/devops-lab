# Exercice — 2026-09-24

Notion cible : **Course Introduction** (Introduction)

## 1. Objectif

Mettre en place un environnement de laboratoire Linux personnel documenté, capable de servir de base aux exercices pratiques du cours LFCS.

---

## 2. Build

### Tâche 1 — Préparer une machine de lab Linux
- Provisionnez une machine virtuelle (ou un conteneur) Linux récente à l’aide de votre outil habituel (Vagrant, Hetzner, Docker…).  
- Configurez un accès SSH fonctionnel avec un utilisateur disposant des droits `sudo`.  
- Installez les outils de base indispensables : éditeur de texte en terminal, client Git, outil de transfert HTTP (`curl`), gestionnaire de paquets déjà présent.

### Tâche 2 — Récupérer et explorer la documentation du cours
- Depuis la machine de lab, téléchargez le fichier d’index de documentation disponible à l’URL : `https://notes.kodekloud.com/llms.txt`.  
- Identifiez dans ce fichier les pages correspondant aux sections principales du cours (commandes essentielles, déploiement, utilisateurs/groupes, réseau, stockage).  
- Ouvrez au moins trois pages de cet index et lisez leur contenu pour comprendre la progression du cours.

### Tâche 3 — Initialiser un suivi de progression versionné
- Créez un répertoire local `lfcs-notes` dans votre machine de lab.  
- Initialisez un dépôt Git dans ce répertoire.  
- Rédigez un fichier `README.md` contenant :  
  - l’objectif de votre préparation LFCS,  
  - la liste des sections du cours repérées dans l’index,  
  - l’état actuel de votre environnement (OS, version, outils installés).  
- Effectuez un premier commit.

---

## 3. Break

### Scénario 1 — Casser puis réparer l’accès SSH
- Provoquez volontairement un échec de connexion SSH en modifiant la configuration du serveur SSH (par exemple : changement de port, désactivation d’une méthode d’authentification, restriction d’accès à un groupe inexistant).  
- Redémarrez le service concerné.  
- Constatez l’impossibilité de vous connecter à distance.  
- Réparez la configuration en utilisant la console directe de la machine (ou la commande `docker exec` si vous utilisez un conteneur).  
- Vérifiez que la connexion SSH fonctionne à nouveau.

### Scénario 2 — Altérer puis restaurer le suivi Git
- Supprimez une ligne importante du fichier `README.md` et enregistrez le fichier.  
- Simulez une perte de données en effectuant un commit de cette version altérée.  
- Restaurez l’état précédent à l’aide de l’historique Git et vérifiez que le fichier est revenu à son contenu initial.

---

## 4. Rappel (interleaving)

Répondez brièvement (sans exécuter de commandes) aux questions suivantes :

1. Comment lister les conteneurs Docker actifs et afficher leur consommation de ressources ?  
2. Quelle commande Git permet de comparer le répertoire de travail avec le dernier commit ?  
3. Sur un système Linux, comment vérifier l’espace disque disponible et la mémoire vive utilisée ?

---

## 5. Intro

La prochaine notion détaille la structure complète du cours de préparation LFCS. Vous y découvrirez l’enchaînement pédagogique des modules, les compétences visées pour chaque section, et la manière dont les laboratoires interactifs viennent renforcer la pratique. Cela vous permettra de planifier efficacement votre apprentissage sur les semaines à venir.

---

## 6. Validation

À l’issue de l’exercice, vous devez être en mesure de présenter :

- La sortie d’une commande montrant que la machine de lab est joignable en SSH sans erreur.  
- Le fichier `llms.txt` téléchargé (ou une capture de sa présence).  
- Une capture du dépôt Git local avec l’historique (`log`) affichant au moins deux commits : l’ajout initial du `README.md` et la restauration après altération.  
- La sortie des commandes de rappel exécutées (questions de la section 4) ou vos réponses écrites.  
- La restauration fonctionnelle du service SSH après le scénario de panne (test de connexion réussi).