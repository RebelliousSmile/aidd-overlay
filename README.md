# AIDD Claude Custom

Collection de commandes personnalisées, agents, règles et templates pour les outils de développement agentique (Claude Code, OpenCode, Cursor, Copilot), conçus pour le framework **AIDD** (AI-Driven Development).

## Priorité d'intégration

| Priorité | Outil | Fréquence d'utilisation |
|----------|-------|--------------------------|
| 1️⃣ | Claude Code | Quotidien |
| 2️⃣ | OpenCode | Quotidien |
| 3️⃣ | GitHub Copilot | Pontuel |
| 4️⃣ | Cursor | Rare |

## Structure du dépôt

```
.
├── commands/custom/           # Slash commands Claude Code (/custom:...)
├── agents/                    # Agents Claude Code
├── rules/custom/              # Règles Claude Code
├── skills/                   # Skills Claude Code
├── templates/custom/          # Templates (copiés dans aidd_docs/)
│
├── .opencode/                 # OpenCode (converti depuis commands/rules)
│   ├── commands/aidd/custom/
│   ├── agents/custom/
│   ├── rules/custom/
│   └── templates/custom/
│
├── instructions/              # Fichiers d'instructions root
│   ├── CLAUDE.md              # Pour Claude Code (root)
│   ├── AGENTS.md              # Pour OpenCode (root)
│   └── copilot-instructions.md  # Pour Copilot
│
├── rules-mdc/custom/         # Règles converties pour Cursor (.mdc)
└── prompts/custom/           # Prompts convertis pour Copilot
```

## Installation automatique

Utiliser `aidd-custom` pour installer automatiquement selon les outils détectés :

```bash
aidd-custom install
```

Détecte automatiquement : `.claude/`, `.opencode/`, `.cursor/`, `.github/`

## Guidelines de rédaction par outil

### 1. Claude Code (priorité最高的)

**Fichiers** : `commands/`, `agents/`, `rules/`, `skills/`, `CLAUDE.md`

**Format** :
- **Commands** : Markdown avec frontmatter YAML, sections `## Goal`, `## Instructions`, steps numérotés
- **Agents** : Markdown avec `## Description`, `## Tools`, instructions détaillées
- **Rules** : Bullet points concis, pas de prose
- **Skills** : Structure libre, invoqué par l'utilisateur

**Conventions** :
- `$ARGUMENTS` pour les arguments
- Backticks pour le code inline
- `$HOME` = projet root
- Utiliser les chemins relatifs

### 2. OpenCode (priorité 2)

**Fichiers** : `.opencode/commands/`, `.opencode/agents/`, `.opencode/rules/`, `AGENTS.md`

**Différences avec Claude** :
- Même format de base, mais estructura légèrement différente
- **Commands** : dossier `commands/aidd/custom/` au lieu de `commands/custom/`
- **Instructions root** : `AGENTS.md` au lieu de `CLAUDE.md`
- **Agents** : dans `.opencode/agents/` directement

**Règles de conversion automatique** :
- Les commands sont copiées telles quelles dans `.opencode/commands/aidd/custom/`
- Les rules sont copiées dans `.opencode/rules/custom/`

### 3. GitHub Copilot (priorité 3)

**Fichiers** : `instructions/`, `prompts/custom/`, `.github/instructions/custom/`

**Format** :
- **Instructions** : `.github/copilot-instructions.md` (root) ou `instructions/` (multi-fichier)
- **Prompts** : `.github/prompts/custom/*.prompt.md`

**Conversion depuis Claude** :
- Les rules sont converties en `*.instructions.md` dans `.github/instructions/custom/`
- Les commands sont converties en `*.prompt.md` dans `.github/prompts/custom/`

**Format instructions** :
```markdown
---
description: <description courte>
---

# <Titre>

<Contenu converti en instructions concises>
```

**Format prompts** :
```markdown
---
description: <description>
---

You are an AI developer assistant...

## Context
<contexte>

## Task
<tâche>

## Output
<format de sortie attendu>
```

### 4. Cursor (priorité 4)

**Fichiers** : `rules-mdc/custom/`, `.cursor/rules/`

**Format MDC** :
```markdown
---
description: <description courte>
---

# <Titre>

<contenu>
```

**Conversion automatique** :
- Les rules `.md` sont converties en `.mdc` avec frontmatter
- Ajout automatique de la description basée sur le filename

## Commandes disponibles

| Commande | Description |
|---|---|
| `/custom:01:agentic_architecture` | Génère l'architecture du projet avec un audit de maturité agentique |
| `/custom:01:migrate_docs` | Scanne les dossiers docs, classifie et reformate selon templates AIDD |
| `/custom:02:release_to_site` | Récupère une release GitHub et traduit en contenu marketing |
| `/custom:03:site_section` | Planifie et implémente une section sur le site (Nuxt + Vue + UnoCSS) |
| `/custom:07:project_status` | Exporte un rapport de statut projet avec audit, sécurité et plan d'action 7 jours |
| `/custom:08:changelog` | Génère ou met à jour CHANGELOG.md à partir de git |
| `/custom:08:end_plan` | Archive le plan en cours, exécute /learn, retourne sur la branche parente |

## Agents

| Agent | Description |
|---|---|
| `ada` | Agent d'apprentissage interactif — quiz sur le codebase et la memory bank |

Déclenchement : "quiz me", "test my knowledge", "learn the codebase", "Ada"

## Règles

| Règle | Description |
|---|---|
| `04-agentic-tooling` | Pratiques de tooling agentique (ARF Principle 3) |
| `04-git-main-protection` | Interdit git commit/push sur main sans validation |
| `04-rules-namespace` | Namespace custom/ pour règles projet |
| `06-agentic-tests` | Pratiques de tests agentiques (ARF Principle 1) |
| `07-agentic-type-safety` | Pratiques de typage agentique (ARF Principle 2) |
| `08-agentic-branching` | Pratiques de branching agentique |
| `08-issue-closing` | Protocol de cloture de ticket avec plan & review |
| `09-aidd-workflow` | Workflow AIDD complet |

## Templates (`aidd_docs/`)

| Template | Description |
|---|---|
| `agentic_readiness_framework.md` | Framework d'évaluation de la maturité agentique |
| `architecture_summary.md` | Résumé de l'architecture technique |
| `audit_score.md` | Grille de scoring pour l'audit agentique |
| `project_status.md` | Rapport de statut projet avec audit, sécurité et plan d'action |
| `quiz_report.md` | Rapport de session de quiz Ada |

## Ajout de nouveau contenu

Pour ajouter une nouvelle règle/command/agent :

1. **Créer le fichier source** pour Claude Code :
   - Commandes → `commands/custom/<phase>/<nom>.md`
   - Règles → `rules/custom/<catégorie>-<nom>.md`
   - Agents → `agents/<nom>.md`

2. **Exporter vers les autres outils** :
   - Copier dans `.opencode/` pour OpenCode
   - Lancer la conversion automatique vers `rules-mdc/` (Cursor) et `prompts/` (Copilot)

3. **Mettre à jour ce README** avec la nouvelle entrée dans le tableau correspondant

## Prérequis

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code)
- [OpenCode](https://github.com/opencodeai/opencode)
- [AIDD](https://github.com/ai-driven-dev/aidd-framework)
- `gh` CLI pour les commandes interagissant avec GitHub