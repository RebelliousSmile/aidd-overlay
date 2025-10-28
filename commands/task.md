---
name: task
description: Exécuter une tâche complète avec test et commit
---

# Workflow d'exécution de tâche

Tu vas exécuter une tâche en suivant ce workflow complet :

## Étapes à suivre :

1. **Lire le fichier de tâche** fourni en paramètre
2. **Exécuter la tâche** selon les instructions du fichier
3. **vérifier si le serveur de développement est lancé par l'utilisateur, sinon le lancer** avec `pnpm run dev` en background
4. **Faire tester les changements** à l'utilisateur
5. **Arrêter le serveur s'il n'était déjà pas lancé avant la tâche** une fois la validation faite
6. **Supprimer le fichier de tâche** une fois qu'elle est complètement terminée
7. **Committer les fichiers modifiés** en utilisant le nom du fichier de tâche comme base pour le message de commit

## Format du message de commit :

```
feat(scope): description basée sur le nom du fichier de tâche

- Liste des modifications effectuées
- Amélioration 1
- Amélioration 2
- Suppression tâche [nom] terminée
```

## Instructions importantes :

- Utilise la TodoWrite tool pour tracker toutes les étapes
- Attends la validation de l'utilisateur avant de supprimer le fichier de tâche
- Ne commite que si l'utilisateur a validé les changements
- Demande confirmation avant chaque étape critique
