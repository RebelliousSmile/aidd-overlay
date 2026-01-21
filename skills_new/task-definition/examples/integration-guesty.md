# Task: Intégrer la mise à jour Guesty dans le flux d'allocation

> **Note**: This is a real task example from the SmartLockers project.
> Use as reference for structure, level of detail, and acceptance criteria.

## Description

Simplifier le flux CosyHosting en intégrant la mise à jour des codes Guesty directement après l'allocation SmartLockers, puis supprimer la route séparée `update-reservation-code` qui complexifie l'architecture.

**Problème actuel** :
- La route `update-reservation-code` existe mais n'est pas appelée automatiquement
- Après une allocation réussie, le code n'est pas renvoyé vers Guesty
- Deux points d'entrée possibles = confusion et maintenance difficile

**Objectif** : Un seul flux intégré :
```
process-reservations
    └── cosyhosting_process_reservation()
            ├── Sauvegarder en DB
            ├── Allouer casier SmartLockers
            └── [NOUVEAU] Mettre à jour Guesty (code + num)
```

## Analyse technique

### Données disponibles après allocation

```php
$allocationResult = reservation_allocate_smartlockers(...);
// Retourne:
// - data.allocation: données d'entrée (ext_ref_locker, ext_ref_user, etc.)
// - data.sync_response: réponse brute API Sync
// - data.sync_response.response: peut contenir le code alloué
```

### Fonction existante pour mise à jour Guesty

```php
// apis/guesty_functions.php:329
api_guesty_update_reservation($reservationId, [
    'locker_code' => $code,      // → keyCode via notes endpoint
    'locker_num' => $lockerNum   // → custom field LockerNum
], 'cosyhosting', $config);
```

### Question clé à résoudre

**D'où vient le code ?** Options possibles :
1. Retourné dans `sync_response` après `MachineAllocateLocker`
2. Généré côté middleware via `sync_generate_access_code()`
3. Requête séparée pour récupérer l'allocation créée

→ **À investiguer** : Structure exacte de la réponse `MachineAllocateLocker`

## Acceptance Criteria

- [ ] Après allocation réussie, Guesty est mis à jour automatiquement avec le code
- [ ] La route `update-reservation-code` est supprimée
- [ ] Le handler `client_cosyhosting_handle_update_reservation_code()` est supprimé
- [ ] PHPStan niveau 6 : 0 erreur
- [ ] Test manuel : vérifier que le code apparaît dans Guesty après cron

## Technical Requirements

### Fichiers à modifier

| Fichier | Modifications |
|---------|---------------|
| `clients/cosyhosting_functions.php` | Ajouter appel `api_guesty_update_reservation()` après allocation réussie |
| `clients/cosyhosting_functions.php` | Supprimer route `update-reservation-code` et handler |
| `apis/guesty_functions.php` | Potentiellement simplifier si logique déplacée |
| `storage/bruno-collections/.../cosyhosting/update-reservation-code.bru` | **Supprimer** |

### Étapes d'implémentation

#### 1. Investigation (30 min)

Déterminer comment obtenir le code après allocation :
```php
// Tester la structure de $allocationResult
error_log("Allocation result: " . json_encode($allocationResult, JSON_PRETTY_PRINT));
```

#### 2. Intégration dans cosyhosting_process_reservation() (45 min)

Après l'allocation réussie (~ligne 2856), ajouter :

```php
if ($allocationResult['success']) {
    // Mise à jour DB existante
    reservation_update_synced_datetime(...);

    // [NOUVEAU] Mettre à jour Guesty avec le code
    $code = $allocationResult['data']['sync_response']['code'] ?? null;
    $lockerNum = $allocationResult['data']['sync_response']['locker_num'] ?? null;

    if ($code && $lockerNum) {
        require_once __DIR__ . '/../apis/guesty_functions.php';
        $guestyConfig = api_guesty_get_config('cosyhosting');

        $guestyUpdateResult = api_guesty_update_reservation(
            $reservationId,
            ['locker_code' => $code, 'locker_num' => $lockerNum],
            'cosyhosting',
            $guestyConfig
        );

        if ($guestyUpdateResult['status'] !== 'success') {
            error_log("Warning: Failed to update Guesty with code for $reservationId");
        }
    }
}
```

#### 3. Suppression de la route (15 min)

- Supprimer l'entrée `"update-reservation-code"` dans `client_cosyhosting_get_routes()`
- Supprimer le handler `client_cosyhosting_handle_update_reservation_code()`

## Risques et mitigations

| Risque | Niveau | Mitigation |
|--------|--------|------------|
| Code non disponible dans sync_response | Moyen | Investigation préalable, fallback possible |
| Échec mise à jour Guesty | Faible | Log warning, ne bloque pas l'allocation |
| Régression sur allocations existantes | Faible | L'allocation reste prioritaire, Guesty = bonus |

## Tests

- [ ] PHPStan niveau 6 : 0 erreur
- [ ] Test manuel : Exécuter cron cosyhosting avec réservation test
- [ ] Vérifier dans Guesty que `keyCode` et `LockerNum` sont mis à jour
- [ ] Vérifier que la route `update-reservation-code` retourne 404

## Definition of Done

- [ ] Code intégré après allocation
- [ ] Route supprimée
- [ ] PHPStan 0 erreur
- [ ] Test cron validé
- [ ] Guesty mis à jour automatiquement
