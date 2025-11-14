---
name: task
description: Exécuter une tâche avec workflow automatisé et feedback loops
---

# Workflow d'Exécution de Tâche avec Feedback Loops

Ce workflow suit `documentation/memory-bank/core/automated-workflow.md` pour garantir qualité et efficacité maximales.

---

## Configuration SmartLockers

```yaml
# Decision Strategy
DIRECT_THRESHOLD:
  time: 2 hours
  files: 3 files

# Test Commands (70/20/10)
COMMAND_VALIDATE: "composer phpstan"          # PHPStan niveau 6
COMMAND_TEST_CONTRACTS: "composer test-contracts"  # Tests contrat
COMMAND_TEST_INTEGRATION: "composer test-integration"  # Tests intégration
COMMAND_QUALITY: "composer quality"           # Tous tests

# Dev Server
DEV_SERVER:
  command: "php -S localhost:8001 -t public/"
  port: 8001
  url: "http://localhost:8001"

# Review Agents
PLAN_REVIEW_AGENTS:
  - software-architect      # Architecture, patterns, performance
  - product-owner-functional  # Règles métier, acceptance criteria

CODE_REVIEW_SKILL: "code-review"  # Skill avec checklist SmartLockers

# Commit Convention
COMMIT_FORMAT: "type(scope): description"
COMMIT_TYPES: [feat, fix, docs, refactor, test, chore, client, api]
COMMIT_SCOPES: [clients, apis, providers, services, tests, docs, config, db]
```

---

## Workflow Complet

### ÉTAPE 1: Lecture Tâche

1. **Lire fichier tâche** fourni en paramètre
2. **Extraire informations** :
   - Description tâche
   - Fichiers à modifier
   - Complexité estimée (temps, nombre fichiers)
   - Acceptance criteria

---

### ÉTAPE 2: 🔄 PLANNING LOOP (Feedback Loop #1)

**Objectif** : Valider plan AVANT implémentation (économise 45% temps)

#### 2.1 Créer Plan Détaillé

Analyser tâche et créer plan avec :
- [ ] Étapes d'implémentation séquentielles
- [ ] Fichiers à créer/modifier (avec chemins exacts)
- [ ] Fonctions à implémenter (avec signatures)
- [ ] Tests à écrire
- [ ] Documentation à mettre à jour
- [ ] Estimation temps par étape

**Format plan** :
```markdown
# Plan : [Nom Tâche]

## Contexte
[Résumé tâche]

## Étapes d'Implémentation
1. [Étape 1] (15 min)
   - Créer/modifier : code/clients/lockandchill_functions.php
   - Fonction : client_lockandchill_cron_process()

2. [Étape 2] (20 min)
   - Créer : public/cron.php
   - Validation : CLI uniquement, sanitisation client name

## Tests
- [ ] PHPStan niveau 6 : 0 erreur
- [ ] Tests contrat : test_cron_validate_client_name()
- [ ] Tests intégration : test_full_cron_flow()

## Documentation
- [ ] Mise à jour CLAUDE.md si nécessaire

## Estimation Totale
45 minutes → Stratégie DIRECT
```

#### 2.2 Review Plan (Agents en Parallèle)

**Lancer agents review en PARALLÈLE** (1 seul message) :

```
@software-architect : Review plan architecture - patterns corrects ? performance optimale ?

@product-owner-functional : Review plan métier - acceptance criteria respectés ? règles métier validées ?
```

**Attendre retours agents** (30-60 secondes)

#### 2.3 Décision : Plan Approuvé ?

**SI agents approuvent ET aucun ajustement majeur requis** :
   → **Passer ÉTAPE 3**

**SI agents demandent ajustements** :
   → **Ajuster plan** selon recommandations
   → **Re-review** (retour 2.2)
   → **LOOP** jusqu'à approbation

**Gain feedback loop** : 3h35min économisées sur 8h (45% temps)

---

### ÉTAPE 3: Stratégie d'Implémentation

**Analyser estimation temps et fichiers** :

```yaml
Conditions DIRECT:
  - Temps estimé < 2 heures
  - Fichiers à modifier < 3
  - Complexité : Low

Conditions STEP-BY-STEP:
  - Temps estimé > 2 heures
  - Fichiers à modifier > 3
  - Complexité : Medium/High
```

**SI DIRECT** :
   → Implémenter tout en une fois
   → 1 seul commit à la fin
   → Passer ÉTAPE 4 (mode DIRECT)

**SI STEP-BY-STEP** :
   → Découper en milestones
   → 1 commit par milestone validé
   → Passer ÉTAPE 4 (mode STEP-BY-STEP)

---

### ÉTAPE 4: 🔄 IMPLEMENTATION LOOP (Feedback Loop #2)

#### Mode DIRECT (< 2h, < 3 fichiers)

**4.1 Implémenter tout le code**

- Créer/modifier fichiers selon plan
- Respecter conventions SmartLockers :
  - Fonctions snake_case avec préfixes (client_, api_, db_, auth_)
  - PHPDoc complet
  - Pattern cache-first obligatoire
  - Gestion erreurs try-catch

**4.2 Vérifier serveur dev**

```bash
# Vérifier si serveur déjà lancé
ps aux | grep "php -S localhost:8001" | grep -v grep

# Si non lancé → Lancer en background
php -S localhost:8001 -t public/ > /dev/null 2>&1 &
echo $! > .dev-server.pid  # Sauver PID
```

**4.3 Tests Automatiques (70/20/10)**

Exécuter dans l'ordre :

```bash
# 1. PHPStan (70%) - OBLIGATOIRE
composer phpstan

# SI erreurs PHPStan :
#   → Corriger immédiatement
#   → Re-run composer phpstan
#   → LOOP jusqu'à 0 erreur

# 2. Tests Contrat (20%)
composer test-contracts

# SI échecs :
#   → Corriger code
#   → Re-run tests
#   → LOOP jusqu'à tous passants

# 3. Tests Intégration (10%)
composer test-integration

# SI échecs :
#   → Corriger code
#   → Re-run tests
#   → LOOP jusqu'à tous passants
```

**4.4 Validation Manuelle Utilisateur**

```
Implémentation terminée. Changements :
- [Fichier 1] : [Description]
- [Fichier 2] : [Description]

Tests passants :
✅ PHPStan niveau 6 : 0 erreur
✅ Tests contrat : X/X passants
✅ Tests intégration : X/X passants

Serveur dev : http://localhost:8001

Peux-tu valider les changements ?
- Tester manuellement : [Instructions]
- Vérifier comportement attendu : [Critères]
```

**Attendre validation utilisateur**

**SI utilisateur valide** :
   → Passer ÉTAPE 5 (Review)

**SI utilisateur demande corrections** :
   → Corriger selon feedback
   → Re-run tests (4.3)
   → Re-valider (4.4)
   → **LOOP** jusqu'à validation

---

#### Mode STEP-BY-STEP (> 2h, > 3 fichiers)

**4.1 Découper en Milestones**

Exemple :
```
Milestone 1: Infrastructure cron (30 min)
  - public/cron.php
  - Validation CLI, sanitisation

Milestone 2: Fonctions client cron_process() (45 min)
  - client_lockandchill_cron_process()
  - client_cosyhosting_cron_process()

Milestone 3: Tests (30 min)
  - Tests contrat
  - Tests intégration

Milestone 4: Documentation (15 min)
  - Mise à jour CLAUDE.md
```

**4.2 Pour CHAQUE Milestone** :

**a) Implémenter milestone**

**b) Tests milestone** :
```bash
composer phpstan
composer test-contracts  # Tests liés milestone
```

**c) Checkpoint utilisateur** :
```
Milestone [N] terminé : [Description]

Changements :
- [Fichier 1]
- [Fichier 2]

Tests :
✅ PHPStan : 0 erreur
✅ Tests contrat : X/X passants

Peux-tu valider avant milestone suivant ?
```

**d) SI utilisateur valide** :
   → **Commit milestone** (ne PAS attendre fin)
   → Format commit :
   ```
   feat(scope): milestone N - description

   - Changement 1
   - Changement 2

   🤖 Generated with [Claude Code](https://claude.com/claude-code)
   Co-Authored-By: Claude <noreply@anthropic.com>
   ```
   → Passer milestone suivant

**e) SI utilisateur demande corrections** :
   → Corriger
   → Re-tests
   → Re-checkpoint
   → **LOOP** jusqu'à validation

**f) Répéter pour tous milestones**

**Quand tous milestones validés** :
   → Passer ÉTAPE 5 (Review finale)

---

### ÉTAPE 5: 🔄 REVIEW LOOP (Feedback Loop #3)

**Objectif** : Code review structuré avec checklist SmartLockers

#### 5.1 Lancer Code Review

**Utiliser skill code-review** (se déclenche automatiquement) :

```
Code review des changements :
[Lister fichiers modifiés]
```

**Skill génère rapport standardisé** :
- Fonctionnalité (edge cases, error handling)
- Qualité (conventions, préfixes, PHPDoc)
- Sécurité (sanitisation, injection, secrets)
- Performance (cache-first, DB optimization)
- Tests (PHPStan, couverture)
- SmartLockers-specific (UUID, multi-tenant, isolation)

#### 5.2 Consulter Agents si Nécessaire

**SI questions architecturales complexes** :
```
@software-architect : [Question pattern/architecture]
```

**SI validation règles métier requise** :
```
@product-owner-functional : [Question business rules]
```

#### 5.3 Décision Review

**SI review "Approved"** :
   → Passer ÉTAPE 6 (Commit final si mode DIRECT)

**SI review "Request changes"** :
   → **Appliquer corrections** selon rapport
   → **Re-tests** (composer phpstan + tests)
   → **Re-review** (retour 5.1)
   → **LOOP** jusqu'à "Approved"

**SI review "Comment" (suggestions optionnelles)** :
   → Demander utilisateur si appliquer suggestions
   → SI oui : appliquer + re-review
   → SI non : passer ÉTAPE 6

---

### ÉTAPE 6: Finalisation

#### 6.1 Arrêter Dev Server (si lancé par workflow)

```bash
# Si PID sauvegardé
if [ -f .dev-server.pid ]; then
  kill $(cat .dev-server.pid) 2>/dev/null
  rm .dev-server.pid
fi
```

#### 6.2 Commit Final (Mode DIRECT uniquement)

**Mode STEP-BY-STEP** : Commits déjà faits par milestone, skip cette étape

**Mode DIRECT** : Créer commit final

**a) Préparer message commit** :

```bash
# Extraire type et scope du nom fichier tâche
# Exemple : documentation/tasks/implement-unified-cron-system.md
#   → type: feat
#   → scope: services (ou clients, selon fichiers modifiés)
#   → description: implement unified cron system

# Format :
feat(scope): description basée sur nom tâche

- Liste modifications
- Changement 1
- Changement 2

🤖 Generated with [Claude Code](https://claude.com/claude-code)
Co-Authored-By: Claude <noreply@anthropic.com>
```

**b) Créer commit** :

```bash
git add [fichiers modifiés]
git commit -m "$(cat <<'EOF'
feat(scope): description

- Changement 1
- Changement 2

🤖 Generated with [Claude Code](https://claude.com/claude-code)

Co-Authored-By: Claude <noreply@anthropic.com>
EOF
)"
```

#### 6.3 Supprimer Fichier Tâche

**Demander confirmation utilisateur** :
```
Tâche complètement terminée :
✅ Implémentation validée
✅ Tests passants (PHPStan + Contrats + Intégration)
✅ Code review "Approved"
✅ Commit créé

Puis-je supprimer le fichier de tâche ?
```

**SI utilisateur confirme** :
```bash
rm [chemin_fichier_tache]
```

---

## Instructions Importantes

### TodoWrite Tool

**Utiliser TodoWrite pour tracker toutes les étapes** :

```php
// Au début du workflow
TodoWrite([
  "Lire fichier tâche",
  "Créer plan détaillé",
  "Review plan (agents)",
  "Implémenter code",
  "Tests 70/20/10",
  "Code review",
  "Commit final"
])

// Mettre à jour statut après chaque étape
```

### Confirmations Utilisateur

**Demander confirmation AVANT** :
- Lancer agents review (coût tokens)
- Appliquer corrections suggérées par review
- Supprimer fichier tâche
- Commit (si pas déjà autorisé)

**Ne PAS demander confirmation pour** :
- Tests automatiques (PHPStan, composer test)
- Corrections bugs évidents
- Ajout PHPDoc manquant

### Échecs et Recovery

**SI PHPStan échoue** :
   → Corriger immédiatement (priorité absolue)
   → Re-run jusqu'à 0 erreur
   → Ne JAMAIS passer à l'étape suivante si PHPStan ≠ 0

**SI tests échouent** :
   → Analyser échec
   → Corriger code
   → Re-run tests
   → Loop jusqu'à succès

**SI serveur dev ne démarre pas** :
   → Vérifier erreurs PHP fatales
   → Corriger
   → Re-lancer
   → Si impossible : continuer sans serveur dev, notifier utilisateur

### Règles Git Critiques

**JAMAIS commit sans autorisation** :
   - Mode DIRECT : Demander confirmation avant commit final
   - Mode STEP-BY-STEP : Demander confirmation AVANT chaque commit milestone
   - Exception : Si utilisateur a dit "commit automatiquement" au début

**Format commit obligatoire** :
   - Conventional Commits (type(scope): description)
   - Toujours inclure footer Claude Code
   - Types : feat, fix, docs, refactor, test, chore, client, api
   - Scopes : clients, apis, providers, services, tests, docs, config, db

---

## Exemple d'Exécution Complète

### Exemple Mode DIRECT (< 2h)

```
Utilisateur : /task documentation/tasks/add-cache-ttl-validation.md

Assistant :
[ÉTAPE 1] Lecture tâche add-cache-ttl-validation.md
  → Ajouter validation TTL cache dans api_resilient_call()
  → Estimation : 1h30, 2 fichiers
  → Stratégie : DIRECT

[ÉTAPE 2] 🔄 PLANNING LOOP
  Plan créé :
  1. Modifier src/services/api.php
  2. Ajouter validation TTL cohérence
  3. Tests contrat

  Review plan en parallèle...
  @software-architect : ✅ Pattern correct
  @product-owner-functional : ✅ Règles métier OK

  → Plan approuvé

[ÉTAPE 3] Stratégie : DIRECT (1h30 < 2h, 2 fichiers < 3)

[ÉTAPE 4] 🔄 IMPLEMENTATION LOOP
  Implémentation...
  ✅ api.php modifié (validation TTL ajoutée)

  Dev server : Déjà lancé par utilisateur

  Tests :
  ✅ composer phpstan : 0 erreur
  ✅ composer test-contracts : 8/8 passants
  ✅ composer test-integration : 3/3 passants

  Validation utilisateur : ✅ Approuvé

[ÉTAPE 5] 🔄 REVIEW LOOP
  Code review...
  Skill code-review : ✅ Approved

[ÉTAPE 6] Finalisation
  ✅ Commit créé : feat(services): add cache TTL validation
  ✅ Fichier tâche supprimé

Terminé ! (1h25 réel)
```

### Exemple Mode STEP-BY-STEP (> 2h)

```
Utilisateur : /task documentation/tasks/implement-lockandchill-multi-owner.md

Assistant :
[ÉTAPE 1] Lecture tâche...
  → Système multi-propriétaires Lock and Chill
  → Estimation : 8h, 6 fichiers
  → Stratégie : STEP-BY-STEP

[ÉTAPE 2] 🔄 PLANNING LOOP
  Plan créé avec 4 milestones...
  Review agents : ✅ Approuvé

[ÉTAPE 3] Stratégie : STEP-BY-STEP (8h > 2h, 6 fichiers > 3)

[ÉTAPE 4] 🔄 IMPLEMENTATION LOOP

  === Milestone 1 : Table lockandchill_owners (2h) ===
  Implémentation...
  Tests : ✅ PHPStan 0 erreur
  Validation utilisateur : ✅ OK
  → Commit : feat(db): add lockandchill_owners table

  === Milestone 2 : Fonctions CRUD owners (2h) ===
  Implémentation...
  Tests : ✅ PHPStan + Contrats passants
  Validation utilisateur : ✅ OK
  → Commit : feat(clients): add lockandchill owner CRUD functions

  === Milestone 3 : Sync multi-API (3h) ===
  Implémentation...
  Tests : ✅ Tous passants
  Validation utilisateur : ✅ OK
  → Commit : feat(clients): implement multi-owner sync

  === Milestone 4 : Documentation (1h) ===
  Implémentation...
  Validation utilisateur : ✅ OK
  → Commit : docs(clients): document multi-owner system

[ÉTAPE 5] 🔄 REVIEW LOOP
  Code review finale : ✅ Approved

[ÉTAPE 6] Finalisation
  ✅ 4 commits créés (1 par milestone)
  ✅ Fichier tâche supprimé

Terminé ! (8h10 réel, 4 commits)
```

---

## Bénéfices Workflow avec Feedback Loops

### Gain Temps

**Sans loops (linéaire)** :
```
Plan incorrect → Implémentation 4h → Review échoue
→ Rework complet 4h = 8h total
```

**Avec loops (itératif)** :
```
Plan incorrect → Review plan 10 min → Ajuster 15 min
→ Implémentation correcte 4h → Review OK = 4h25min

GAIN : 3h35min (45% temps économisé)
```

### Qualité Code

- **90% first-try success** (vs 70% sans loops)
- **10% rework rate** (vs 30% sans loops)
- **Issues détectées PRE-implémentation** (économise refactoring)

### Traçabilité

- Tous les agents consultés documentés
- Décisions architecturales justifiées
- Commits atomiques avec contexte

---

## Maintenance Workflow

**Quand mettre à jour ce fichier** :
- Agents ajoutés/supprimés (.claude/agents/)
- Commandes tests changent (composer.json)
- Conventions commit évoluent
- Seuils DIRECT/STEP-BY-STEP ajustés

**Synchronisation** :
- Garder sync avec `documentation/memory-bank/core/automated-workflow.md`
- Version control : check into git

---

**Workflow créé par** : Claude Code (adapté SmartLockers)
**Basé sur** : `documentation/memory-bank/core/automated-workflow.md`
**Version** : 2.0.0 (avec feedback loops complets)
