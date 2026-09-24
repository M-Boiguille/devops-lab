# devops-lab

Exercices DevOps générés à la volée (spirale + spaced repetition) depuis les
notes KodeKloud. Chaque exercice = une branche + une PR : la mission (`mission.md`)
est fournie, tu complètes `answer.md` et tu committes tes artefacts.

## Comment ça marche

1. Le matin, ton coach (OpenClaw) te livre l'exercice du jour.
2. Tu travailles dans ton lab (k3s, VMs, docker), tu commits tes artefacts + `answer.md`.
3. Le coach review la PR (commentaires interactifs) → `APPROVED` ou `CHANGES REQUESTED`.
4. `APPROVED` → merge → la notion est validée (niveau ↑). `CHANGES REQUESTED` → tu corriges.

## Structure

```
exercises/
  <date>-<notion>/
    mission.md    # l'exercice généré
    answer.md     # ta réponse / compte-rendu
    artifacts/    # tes artefacts (manifests, scripts, configs)
```
