# API : ${ApiName}

**Date création** : ${date}
**Documentation officielle** : ${docs_url}
**Client(s)** : ${client_list}

## Vue d'Ensemble

[Description de l'API externe et cas d'usage]

## Authentification

**Type** : ${auth_type}

**Configuration** (`code/clients/config/${client}.cfg`) :
```ini
[${ApiName}]
api_${api_name}_base_url=${base_url}
api_${api_name}_auth_type=${auth_type}
${auth_config_example}
```

## Endpoints Intégrés

### GET /resources - Récupérer ressources

**Fonction** : `api_${api_name}_get_resources()`

**Paramètres** :
| Param | Type | Description |
|-------|------|-------------|
| `limit` | int | Nombre max résultats |
| `offset` | int | Décalage pagination |

**Cache** : ${ttl_resources} secondes

**Pattern** : Cache-first avec fallback stale cache

**Exemple** :
```php
$config = client_get_api_config('${client}', '${ApiName}');
$result = api_${api_name}_get_resources('${client}', $config, ['limit' => 100]);

if ($result['status'] === 'success') {
    $resources = $result['data'];
} elseif ($result['status'] === 'degraded') {
    // API down mais données cache disponibles
    $staleResources = $result['data'];
}
```

### POST /resources - Créer ressource

**Fonction** : `api_${api_name}_create_resource()`

**Pattern** : API-first (pas de cache)

### PUT /resources/:id - Mettre à jour ressource

**Fonction** : `api_${api_name}_update_resource()`

**Pattern** : API-first (pas de cache)

### DELETE /resources/:id - Supprimer ressource

**Fonction** : `api_${api_name}_delete_resource()`

**Pattern** : API-first (pas de cache)

## Rate Limits

${rate_limits_info}

## Gestion d'Erreurs

### Erreurs Courantes

| Code | Cause | Solution |
|------|-------|----------|
| 401 | Token invalide/expiré | Vérifier config, renouveler token |
| 429 | Rate limit | Augmenter TTL cache |
| 500 | Erreur serveur API | Utiliser cache fallback |

## Tests

```bash
# Tests de contrat
php code/tests/contracts/test_api_${api_name}.php

# PHPStan
composer phpstan

# Tests complets
composer test
```

## Références

- **Documentation officielle** : ${docs_url}
- **Code source** : `code/apis/${api_name}_functions.php`
- **Tests** : `code/tests/contracts/test_api_${api_name}.php`
- **Config** : `code/clients/config/${client}.cfg`

## Changelog

### ${date} - Création initiale
- Intégration API ${ApiName}
- Authentification ${auth_type}
- Pattern cache-first implémenté
