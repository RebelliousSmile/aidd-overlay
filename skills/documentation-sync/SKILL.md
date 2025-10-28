---
name: documentation-sync
description: Automatically maintain documentation after code changes. Use PROACTIVELY when functions are added/modified, tables created, APIs changed, or user mentions documentation updates. Triggers on PHP file modifications, schema changes, new functions without PHPDoc.
tools: Read, Write, Edit, Grep, Glob, Bash
model: inherit
---

# Documentation Sync Skill

Automatise la mise à jour de la documentation après des changements de code.

## Déclenchement Proactif

**Utilise cette skill automatiquement quand :**
- Des fonctions PHP sont ajoutées ou modifiées dans `code/clients/`, `code/apis/`, `code/providers/`, `database/`
- Des tables de base de données sont créées ou modifiées
- Des routes API sont modifiées
- PHPDoc manquant détecté sur fonctions publiques
- L'utilisateur mentionne : "doc", "documentation", "mettre à jour doc", "sync doc"

## Étape 0 : Initialiser le tracking

Utilise TodoWrite pour créer une todo list de suivi avec ces tâches :
- Analyser les changements récents (git diff)
- Identifier les fichiers de documentation impactés
- Générer les mises à jour nécessaires
- Valider la cohérence avec le code
- Créer un rapport de mise à jour

Marque chaque tâche comme `in_progress` avant de l'exécuter et `completed` après.

## Étape 1 : Analyser les changements

### 1.1 Détecter les modifications

Exécute `git diff` pour identifier les changements récents :
```bash
git diff HEAD~1 HEAD --name-status
```

Si l'utilisateur spécifie un commit ou une branche, utilise-le à la place.

### 1.2 Catégoriser les changements

Pour chaque fichier modifié, identifie la catégorie :

**Code PHP modifié** (nécessite mise à jour documentation) :
- `clients/*.php` → `documentation/clients/*.md`
- `apis/*.php` → `documentation/api/*.md`
- `providers/*.php` → `documentation/api/*.md`
- `database/*.php` → `documentation/database/*.md` + `documentation/architecture/database-schema-complete.md`
- `routes/*.php` → `documentation/api/*.md`

**Nouvelles fonctions ajoutées** :
- Extraire les signatures de fonctions avec `grep -n "^function "`
- Vérifier la présence de PHPDoc
- Identifier le préfixe (`client_`, `api_`, `provider_`, `db_`, `auth_`)

**Nouvelles tables/migrations** :
- `code/scripts/migrate.php` modifié → `documentation/database/*.md`
- Nouvelles tables → `documentation/architecture/database-schema-complete.md`

## Étape 2 : Identifier les documents impactés

### 2.1 Mapping automatique

Pour chaque changement, détermine les fichiers de documentation à mettre à jour :

| Changement Code | Documentation Impactée |
|-----------------|------------------------|
| `clients/cosyhosting.php` | `documentation/api/guesty.md` |
| `clients/onet.php` | `documentation/clients/onet.md`, `documentation/api/pilotphone.md` |
| `clients/halpades.php` | `documentation/clients/halpades.md` |
| `apis/sync.php` | `documentation/api/sync.md` |
| `apis/guesty.php` | `documentation/api/guesty.md` |
| `database/mysql.php` | `documentation/architecture/database-schema-complete.md` |
| `routes/*.php` | `documentation/api/README.md` |
| `authentication.php` | `documentation/authentication.md` |

### 2.2 Documentation transversale

Certains changements impactent plusieurs documents :

**Architecture modifiée** :
- Changements structurels → `documentation/architecture/03-component-architecture.md`
- Nouveaux patterns → `documentation/developpement/patterns-architecture.md`
- Sécurité → `documentation/architecture/06-security-architecture.md`

**Nouvelles fonctionnalités** :
- User stories → `documentation/fonctionnel/user-stories.md`
- Parcours utilisateur → `documentation/fonctionnel/parcours-utilisateur.md`

## Étape 3 : Générer les mises à jour

### 3.1 Documentation API

Pour chaque fonction API modifiée/ajoutée :

1. **Lire le code source** et extraire :
   - Signature de la fonction
   - Paramètres (types, descriptions PHPDoc)
   - Valeur de retour
   - Exemple d'utilisation dans le code

2. **Mettre à jour le fichier Markdown** correspondant :
   ```markdown
   ### `api_function_name($param1, $param2, $config)`

   **Description** : [À partir du PHPDoc]

   **Paramètres** :
   - `$param1` (type) : Description
   - `$param2` (type) : Description
   - `$config` (array) : Configuration client

   **Retour** : array avec structure :
   ```php
   [
       'status' => 'success|error',
       'data' => [...],
       'source' => 'api|cache'
   ]
   ```

   **Exemple** :
   ```php
   $result = api_function_name($data, 'cosyhosting', $config);
   ```
   ```

### 3.2 Documentation Database

Pour chaque nouvelle table ou modification de schéma :

1. **Créer/mettre à jour** `documentation/database/{table_name}.md` :
   ```markdown
   # Table `{table_name}`

   ## Description
   [Description fonctionnelle]

   ## Schéma
   ```sql
   CREATE TABLE {table_name} (
       id INT PRIMARY KEY AUTO_INCREMENT,
       -- colonnes...
   );
   ```

   ## Colonnes
   | Colonne | Type | Description | Contraintes |
   |---------|------|-------------|-------------|
   | id | INT | Identifiant unique | PRIMARY KEY |

   ## Index
   - PRIMARY KEY sur `id`
   - INDEX sur `{colonne}` (performance requêtes)

   ## Relations
   - Foreign key vers `{autre_table}`

   ## Utilisation
   Utilisée par : `fonction_php()` dans `fichier.php`
   ```

2. **Mettre à jour** `documentation/architecture/database-schema-complete.md` :
   - Ajouter la nouvelle table dans la section appropriée
   - Mettre à jour les diagrammes si nécessaire

### 3.3 Vérification PHPDoc

Pour chaque fonction publique sans PHPDoc ou avec PHPDoc incomplète :

1. **Générer automatiquement** le PHPDoc :
   ```php
   /**
    * [Description de la fonction à partir du nom et du code]
    *
    * @param type $param Description du paramètre
    * @param array $config Configuration client
    * @return array Structure de retour
    * @throws Exception Description des erreurs possibles
    */
   function api_example($param, array $config): array
   {
       // code...
   }
   ```

2. **Demander validation** à l'utilisateur avant d'appliquer

## Étape 4 : Valider la cohérence

### 4.1 Vérifications automatiques

Exécute ces vérifications :

**Cohérence code-documentation** :
- Toutes les fonctions publiques documentées dans les .md
- Schémas de tables à jour dans `database-schema-complete.md`
- Exemples de code testables et fonctionnels

**Conventions respectées** :
- Nommage `snake_case` avec préfixes
- PHPDoc présent sur toutes fonctions publiques
- Format de retour standardisé pour APIs

**Architecture respectée** :
- Pattern cache-first utilisé
- Isolation multi-tenant (tables préfixées)
- Authentification Bearer Token only

### 4.2 Rapport de cohérence

Génère un rapport :
```markdown
## Rapport de Cohérence Documentation

### ✅ Validations réussies
- X fonctions documentées
- Y tables à jour dans le schéma
- Z exemples testés

### ⚠️ Avertissements
- Fonction `xyz()` sans PHPDoc
- Table `abc` manquante dans database-schema-complete.md
- Exemple obsolète dans api/sync.md

### ❌ Erreurs critiques
- Pattern cache non respecté dans `code/apis/xyz.php:123`
- Isolation multi-tenant violée dans `code/clients/abc.php:456`
```

## Étape 5 : Proposer les mises à jour

### 5.1 Modifications suggérées

Pour chaque fichier de documentation à modifier :

1. **Afficher un diff** des changements proposés
2. **Demander confirmation** à l'utilisateur
3. **Appliquer les modifications** si accepté

### 5.2 Nouveaux fichiers

Si de nouveaux fichiers de documentation sont nécessaires :

1. **Proposer la création** avec le template approprié :
   - `documentation/api/{service}.md` pour nouvelles APIs
   - `documentation/database/{table}.md` pour nouvelles tables
   - `documentation/clients/{client}.md` pour nouveaux clients

2. **Remplir automatiquement** avec les données extraites du code

## Étape 6 : Générer le rapport final

Affiche un rapport complet :

```markdown
# Rapport de Mise à Jour Documentation

## 📊 Résumé

- **Fichiers code analysés** : X fichiers
- **Fonctions ajoutées/modifiées** : Y fonctions
- **Tables modifiées** : Z tables
- **Documents mis à jour** : W fichiers

## 📝 Changements Appliqués

### Documentation API
- [x] `documentation/api/sync.md` - Ajout fonction `sync_new_function()`
- [x] `documentation/api/guesty.md` - Mise à jour `guesty_get_reservations()`

### Documentation Database
- [x] `documentation/database/new_table.md` - Création
- [x] `documentation/architecture/database-schema-complete.md` - Ajout table

### Documentation Code
- [x] PHPDoc ajouté sur 3 fonctions
- [x] Exemples mis à jour dans 2 fichiers

## ⚠️ Actions Requises

- [ ] Valider les exemples de code dans `documentation/api/sync.md`
- [ ] Compléter la description métier de la table `new_table`
- [ ] Tester les endpoints modifiés avec Bruno

## 🚀 Prochaines étapes

1. Exécuter `php code/scripts/generate_bruno_collection.php` (si APIs modifiées)
2. Tester avec `composer test`
3. Valider avec `composer phpstan`
4. Commit avec message : "docs: update documentation after [description changes]"
```

## Règles Importantes

### ❌ Ne JAMAIS

- Supprimer de la documentation existante sans validation explicite
- Modifier les exemples de code sans les tester
- Créer de nouveaux fichiers de documentation sans demander
- Écraser les descriptions métier rédigées manuellement

### ✅ TOUJOURS

- Préserver les descriptions fonctionnelles existantes
- Valider les changements avec l'utilisateur avant application
- Maintenir la cohérence avec `CLAUDE.md`
- Vérifier la cohérence cross-référence entre documents

## Historical Reference

**Avant de mettre à jour la documentation**, consulte les mises à jour précédentes :
```bash
ls documentation/reviews/
ls documentation/tasks/
```

Utilise ces exemples historiques pour :
- Maintenir la cohérence du style de documentation
- Suivre les patterns établis dans les reviews précédentes
- Apprendre des erreurs corrigées dans les tasks
- Assurer la continuité avec le travail passé

**Exemples de références utiles :**
- Reviews de code qui ont modifié la doc
- Tasks qui ont créé de nouvelles sections de documentation
- Patterns de mise à jour établis dans le projet

## Notes Techniques

- Utilise `grep`, `git diff`, et `Read` pour l'analyse du code
- Respecte les formats Markdown existants
- Préserve les commentaires et sections manuelles
- Génère des exemples de code testables
- Valide la syntaxe PHP des exemples générés

## Intégration avec Workflow

Cette skill s'intègre automatiquement dans le workflow de développement :

```bash
# 1. Développement
vim apis/sync.php

# 2. Tests
composer test

# 3. Documentation (AUTOMATIQUE via skill)
# La skill se déclenche automatiquement

# 4. Bruno collection (SI API)
php code/scripts/generate_bruno_collection.php

# 5. Validation
composer phpstan

# 6. Commit
git add .
git commit -m "feat: add new sync endpoint + update docs"
```
