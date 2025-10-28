# Analyze API Cache

Analyse les routes API interrogées et les données mises en cache pour un client, puis propose un schéma de consolidation en base de données avec tables de test.

## Usage

```
/analyze-api-cache <client_name>
```

**Paramètres :**
- `client_name` (requis) : Nom du client en minuscules (ex: "halpades", "onet", "cosyhosting")

## Fonctionnalités

La commande effectue les opérations suivantes :

### 1. Analyse du Code
- Parcourt les fichiers `code/clients/{client}_functions.php` et `code/apis/*_functions.php`
- Identifie tous les appels `api_store_result()` pour découvrir les clés de cache
- Extrait les variables de données et TTL associées

### 2. Analyse de la Base de Données
- Vérifie l'existence de la table `{client}_api_cache`
- Récupère les entrées en cache existantes (max 100 dernières)
- Analyse la structure JSON des données stockées

### 3. Génération de Propositions
- Propose des tables de consolidation basées sur les patterns détectés :
  - `{client}_reservations` : Réservations
  - `{client}_vehicles` : Véhicules
  - `{client}_emails` : Emails
  - `{client}_contacts` : Contacts
  - `{client}_materiels` : Matériels
  - `{client}_agents` : Agents
  - `{client}_assignations` : Assignations
  - `{client}_guests` : Invités
  - `{client}_listings` : Propriétés

### 4. Tables de Test en Doublon
- Pour chaque table proposée, génère automatiquement une table `test_{table_name}`
- Structure identique pour permettre les tests sans impacter les données de production

### 5. Fichier de Migration
- Crée un fichier de migration dans `code/src/migrations/`
- Contient les CREATE TABLE pour tables principales et test
- Contient les DROP TABLE pour rollback (down)
- Prêt à être exécuté avec `php code/scripts/migrate.php up`

## Sortie

La commande génère :

1. **Rapport d'analyse** :
   - Liste des clés de cache découvertes
   - Structures de données analysées
   - Tables proposées avec leur SQL

2. **Fichier de migration** :
   - `code/src/migrations/{timestamp}_consolidate_{client}_data.php`
   - Tables principales + tables test_
   - Fonctions up() et down()

## Exemple

### Analyser le cache pour Halpades

```
/analyze-api-cache halpades
```

Cette commande va :
1. Analyser `code/clients/halpades_functions.php`
2. Analyser `code/apis/msexchange_functions.php` (utilisé par Halpades)
3. Lire la table `halpades_api_cache`
4. Proposer des tables comme :
   - `halpades_reservations` + `test_halpades_reservations`
   - `halpades_vehicles` + `test_halpades_vehicles`
   - `halpades_emails` + `test_halpades_emails`
5. Créer la migration `code/src/migrations/20251006120000_consolidate_halpades_data.php`

### Exécution de la migration

Après génération :
```bash
php code/scripts/migrate.php up
```

## Structure des Tables Proposées

Chaque table de consolidation contient :

### Champs Communs
- `id` : INT AUTO_INCREMENT PRIMARY KEY
- `external_id` : VARCHAR(255) NOT NULL UNIQUE (ID API externe)
- `data` : LONGTEXT NOT NULL (JSON complet des données)
- `created_at` : DATETIME NOT NULL
- `updated_at` : DATETIME NOT NULL
- `synced_at` : DATETIME DEFAULT NULL

### Champs Spécifiques selon le Type

**Réservations :**
- `start_date`, `end_date`, `status`, `customer_email`

**Véhicules :**
- `plate_number`, `model`, `status`

**Agents :**
- `nom`, `prenom`, `email`, `status`

## Cas d'Usage

### 1. Nouveau Client
```bash
# Créer d'abord la table de cache
/create-client-migration newclient
php code/scripts/migrate.php up

# Analyser et proposer consolidation
/analyze-api-cache newclient
php code/scripts/migrate.php up
```

### 2. Client Existant
```bash
# Analyser les données en cache existantes
/analyze-api-cache onet

# Réviser les propositions si nécessaire
# Puis exécuter la migration
php code/scripts/migrate.php up
```

### 3. Tests
```bash
# Les tables test_ sont créées automatiquement
# Utiliser dans les tests :
php tests/clients/halpades/test_consolidation.php
```

## Notes Importantes

- ✅ Les tables `test_*` sont créées automatiquement
- ✅ Structure identique aux tables de production
- ✅ Permet tests sans risque pour les données réelles
- ⚠️ Vérifier les propositions avant d'exécuter la migration
- ⚠️ Adapter les champs spécifiques selon les besoins métier

## Limitations

- Analyse limitée aux 100 dernières entrées de cache
- Détection automatique basée sur les patterns de noms
- Structures génériques à adapter selon les besoins spécifiques
- Ne supprime pas les anciennes données de cache

## Voir Aussi

- `/create-client-migration` : Créer la table de cache initiale
- `code/scripts/migrate.php` : Exécuter les migrations
- `documentation/architecture/database-schema-complete.md` : Schéma complet
