---
name: review-and-fix
description: Automatise code review et corrections des problèmes critiques
---

# Commande : Review and Fix

Tu vas automatiser le processus complet de code review et corrections.

## Étape 0 : Initialiser le tracking

Utilise TodoWrite pour créer une todo list de suivi avec ces tâches :
- Lire le fichier de review
- Analyser les problèmes critiques
- Créer les tâches de correction (une par problème critique)
- Exécuter les corrections
- Valider les corrections (PHPStan + Tests + Serveur PHP)
- Nettoyer les tâches terminées
- Générer la nouvelle review (écrase l'ancienne)

Marque chaque tâche comme `in_progress` avant de l'exécuter et `completed` après.
Inscris un identifiant de commit dans la code review pour analyser s'il est pertinent de refaire une analyse du code (+ de 10 commits -> oui).

## Étape 1 : Lire le fichier de review

Demande à l'utilisateur quel fichier de review analyser.

Si l'utilisateur ne fournit pas de nom de composant ou de module, extrait-le du nom du fichier (ex: `sync-api-review.md` → `sync-api`).

## Étape 2 : Analyser les problèmes critiques

Parse le contenu de la review et identifie tous les problèmes marqués comme **Critique** ou **CRITIQUE**.

Pour chaque problème identifié, extrais :
- Le titre du problème
- La description complète
- Les fichiers concernés avec leurs numéros de ligne (format `fichier.php:123`)
- La section dans laquelle le problème apparaît

## Étape 3 : Créer les tâches de correction

Pour chaque problème critique identifié, crée une tâche dans `documentation/tasks/`.

Nomme les tâches selon ce pattern : `fix-{module}-{index}-{description-courte}.md`

Chaque tâche doit contenir (format Markdown) :
- **Titre** : Nom explicite du problème
- **Contexte** : Résumé du problème identifié
- **Fichiers concernés** : Liste avec chemins et numéros de ligne
- **Plan de correction** : Étapes détaillées avec exemples de code PHP
- **Critères de validation** : Tests à exécuter (`composer test`, `composer phpstan`)
- **Conventions à respecter** : `snake_case`, préfixes fonctionnels, PHPDoc

## Étape 4 : Exécuter les corrections

Pour chaque tâche créée :
1. Lis le fichier de tâche
2. Applique les corrections nécessaires aux fichiers identifiés
3. Vérifie que les modifications sont correctes
4. Valide les corrections (voir Étape 5)
5. Marque la tâche comme terminée

## Étape 5 : Valider les corrections

**CRITIQUE** : Après chaque correction ou ensemble de corrections, exécute OBLIGATOIREMENT dans l'ordre :

1. **PHPStan niveau 5** : `composer phpstan`
   - Doit retourner 0 erreur
   - Si erreurs : corriger avant de continuer

2. **Tests de contrat** (si présents) : `composer test-contracts` ou tests PHP manuels
   - Tous les tests doivent passer
   - Si échecs : corriger avant de continuer

3. **Test démarrage serveur PHP** : `timeout 3 php -S localhost:8001 -t public/ 2>&1`
   - Le serveur doit démarrer sans erreur fatale
   - Vérifie qu'aucune fonction n'est redéclarée (conflit de noms)
   - Si erreur fatale : corriger avant de continuer

**Si une seule validation échoue, la correction est considérée comme incomplète.**

## Étape 6 : Nettoyer les tâches terminées

Supprime uniquement les fichiers de tâches qui ont été complètement terminées sans erreur ET validées (Étape 5).

## Étape 7 : Générer une nouvelle code review

Génère une nouvelle code review complète du module après corrections, en analysant en profondeur :
- **Performance et optimisations** : Boucles, requêtes DB, caching, résilience des données
- **Maintenabilité du code** : Lisibilité, découplage, architecture fonctionnelle pure
- **Best practices PHP** :
  - Conventions de nommage (`snake_case` avec préfixes `client_`, `api_`, `provider_`, `db_`, `auth_`)
  - Documentation PHPDoc obligatoire
  - Analyse PHPStan niveau 5
  - Gestion d'erreurs avec try/catch et error_log
- **Architecture** : Cohérence avec les 3 couches (clients/apis/providers), pattern cache-first
- **Sécurité** : Sanitisation des données, validation des autorisations client-first

Cette analyse détaillée déclenchera automatiquement l'agent senior-code-reviewer.

Compare avec la review initiale et documente les améliorations apportées.

**IMPORTANT** : Écrase le fichier de review original (celui fourni en entrée) avec la nouvelle version. Ne crée PAS un nouveau fichier avec un nom différent.

## Format de détection des problèmes

Recherche ces patterns dans le fichier de review :

### Pattern 1 : Emoji rouge avec CRITIQUE en majuscules (prioritaire)
```markdown
- [🔴] **CRITIQUE** : `fichier.php:123` Description du problème (suggestion)
```

### Pattern 2 : Section "Résumé des problèmes critiques"
```markdown
## Résumé des problèmes critiques
### 🔴 Problèmes critiques identifiés
1. **Titre du problème** - `fichier.php:123`
```

### Pattern 3 : Anciens formats (compatibilité)
```markdown
**Critique** : Description avec `fichier.php:123`
**CRITIQUE** : Autre description avec `autre.php:456`
```

**Extraction automatique** :
- Capture le fichier et le numéro de ligne avec regex : `` `([^:]+\.php):(\d+)` ``
- Capture la description complète du problème
- Capture la suggestion de correction (entre parenthèses)

## Sortie attendue

Affiche un rapport détaillé :
- Nombre de problèmes critiques identifiés
- Tâches créées
- Tâches exécutées avec succès
- Tâches en erreur (à conserver pour debug)
- Résumé des améliorations dans la nouvelle review

## Notes importantes

- Ne supprime JAMAIS une tâche en erreur
- Valide chaque correction avant de passer à la suivante (voir Étape 5)
- Documente toutes les modifications apportées
- Assure-toi que la nouvelle review reflète bien l'état après corrections
- **OBLIGATOIRE** : Exécute les 3 validations (PHPStan + Tests + Serveur PHP) avant de marquer une correction comme terminée
- Si le serveur PHP ne démarre pas (erreur fatale), la correction est INCOMPLÈTE

## Exemple de workflow complet

### 1. Review initiale générée
```markdown
### Security
- [🔴] **CRITIQUE** : `database/mysql.php:287` SQL injection via construction dynamique de nom de table (utiliser db_sanitize_table_name())
- [🟡] **Avertissement** : `routes/allocations.php:180` Timeout manquant sur requête DB
```

### 2. Détection automatique
La commande extrait :
- Problème 1 : SQL Injection → `database/mysql.php:287`
- Problème 2 : (Ignoré car 🟡 non-critique)

### 3. Tâche créée
Fichier : `documentation/tasks/fix-database-1-sql-injection.md`

Contenu :
```markdown
# Fix SQL Injection - database/mysql.php

## Contexte
SQL injection via construction dynamique de nom de table détecté dans `database/mysql.php:287`

## Fichiers concernés
- `database/mysql.php:287`

## Plan de correction
1. Créer la fonction `db_sanitize_table_name($tableName)` avec whitelist
2. Appliquer la sanitisation à la ligne 287
3. Documenter avec PHPDoc

## Critères de validation
- `composer phpstan` : Aucune erreur
- `composer test` : Tests passants
- Conventions : `snake_case` + préfixe `db_`
```

### 4. Correction appliquée
Ajout de `db_sanitize_table_name()` dans `database/mysql.php`

### 5. Review mise à jour (écrase l'originale)
```markdown
### Security
- [🟢] SQL injection risks - Corrigé avec db_sanitize_table_name()
- [🟡] **Avertissement** : `routes/allocations.php:180` Timeout manquant (reste à faire)

**Score global** : 8/10 (était 4/10)
**Décision** : ✅ APPROUVÉ avec réserves mineures
```
