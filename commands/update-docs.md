---
name: update-docs
description: Maintient la documentation à jour après changements de code (sync code → docs)
---

# Commande : Update Documentation

Tu vas automatiser la mise à jour de la documentation après des changements de code.

**NOTE** : Cette commande se concentre sur la **synchronisation code → documentation**.
Pour l'**optimisation de la memory bank** et le **nettoyage de fichiers temporaires**,
utilise plutôt `/optimize-memory` ou `/clean-docs` (agent `documentation-architect`).

## Complémentarité avec documentation-architect

- `/update-docs` : Après modification de code (sync automatique)
- `/optimize-memory` : Maintenance memory bank (optimisation périodique)
- `/clean-docs` : Nettoyage fichiers temporaires (archivage/suppression)

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

## Étape 4 : Valider les modifications

### 4.1 Vérifications basiques

**Avant d'appliquer les changements, vérifier** :
- Syntaxe Markdown valide
- Exemples de code PHP syntaxiquement corrects
- Liens internes vers fichiers existants
- PHPDoc bien formaté

**NOTE** : Pour un audit complet de la cohérence documentation/code,
utilise `/optimize-memory` qui délègue à `documentation-architect`.

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

Affiche un rapport concis (< 20 lignes) :

```markdown
# 📝 Rapport Mise à Jour Documentation

**Résumé** : X fonctions documentées, Y tables ajoutées

## Changements Appliqués
- ✅ `api/sync.md` - Ajout `sync_new_function()`
- ✅ `database-schema-complete.md` - Table `new_table`
- ✅ PHPDoc ajouté sur 3 fonctions

## Prochaines étapes
1. `php code/scripts/generate_bruno_collection.php` (si APIs modifiées)
2. `composer test && composer phpstan`
3. Commit : "docs: update after [changes]"

**Optimisation** : Si docs volumineuses créées, exécute `/optimize-memory`
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
- Respecter les templates existants dans `documentation/templates/`
- Maintenir la cohérence avec `CLAUDE.md`
- Vérifier la cohérence cross-référence entre documents

## Options Avancées

### Analyse ciblée

L'utilisateur peut spécifier :
- **Fichier spécifique** : `/update-docs routes/sync.php`
- **Répertoire** : `/update-docs clients/`
- **Commit range** : `/update-docs HEAD~5..HEAD`
- **Type de doc** : `/update-docs --api` (seulement documentation API)

### Modes d'exécution

- **Mode interactif** (par défaut) : Demande confirmation pour chaque changement
- **Mode automatique** : `--auto` - Applique tous les changements sans confirmation
- **Mode rapport seul** : `--dry-run` - Affiche seulement ce qui serait modifié

## Exemple de Workflow Complet

### 1. Développeur modifie du code

```bash
# Modifications dans apis/sync.php
git diff apis/sync.php
```

### 2. Exécution de la commande

```bash
/update-docs apis/sync.php
```

### 3. Analyse automatique

```
🔍 Analyse des changements...

Fichier : apis/sync.php
- Fonction ajoutée : sync_new_endpoint($data, $clientName, $config)
- Fonction modifiée : sync_get_allocations() - Nouveau paramètre $filters

Documentation impactée :
- documentation/api/sync.md (à mettre à jour)
```

### 4. Propositions de mise à jour

```markdown
Mise à jour de documentation/api/sync.md

+ ### `sync_new_endpoint($data, $clientName, $config)`
+
+ **Description** : Nouvelle fonction pour gérer l'endpoint XYZ
+
+ **Paramètres** :
+ - `$data` (array) : Données à traiter
+ - `$clientName` (string) : Nom du client
+ - `$config` (array) : Configuration client
+
+ **Retour** : array avec structure standardisée
+
+ **Exemple** :
+ ```php
+ $result = sync_new_endpoint($data, 'cosyhosting', $config);
+ ```

Appliquer cette modification ? [Y/n]
```

### 5. Validation et application

```
✅ Modifications appliquées
💡 N'oubliez pas : php code/scripts/generate_bruno_collection.php

📋 Rapport complet généré
```

## Intégration avec Workflow Git

Cette commande s'intègre dans le workflow standard :

```bash
# 1. Développement
vim apis/sync.php

# 2. Tests
composer test

# 3. Documentation (AUTOMATIQUE)
/update-docs apis/sync.php

# 4. Bruno collection (SI API)
php code/scripts/generate_bruno_collection.php

# 5. Validation
composer phpstan

# 6. Commit
git add .
git commit -m "feat: add new sync endpoint + update docs"
```

## Notes Techniques

- Utilise `grep`, `git diff`, et `Read` pour l'analyse du code
- Respecte les formats Markdown existants
- Préserve les commentaires et sections manuelles
- Génère des exemples de code testables
- Valide la syntaxe PHP des exemples générés
