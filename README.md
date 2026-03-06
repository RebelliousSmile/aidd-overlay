# AIDD Claude Custom Commands

Collection de commandes personnalisées (slash commands), agents, règles et templates pour [Claude Code](https://docs.anthropic.com/en/docs/claude-code), conçus pour le framework **AIDD** (AI-Driven Development).

## Structure du dépôt

```
.
├── commands/custom/    # Slash commands (/custom:...)
├── agents/             # Agents spécialisés
├── rules/custom/       # Règles appliquées automatiquement
├── skills/             # Skills invocables
└── templates/custom/   # Templates copiés dans aidd_docs/ du projet cible
```

> **Note** : le contenu du dossier `templates/` est conçu pour être copié dans le dossier `aidd_docs/` de votre projet cible.

## Commandes disponibles

| Commande | Description |
|---|---|
| `/custom:01:agentic_architecture` | Génère l'architecture du projet avec un audit de maturité agentique — score le projet selon l'Agentic Readiness Framework avant de concevoir agents, skills et commandes |
| `/custom:01:migrate_docs` | Scanne les dossiers `docs/` et `documentation/`, classifie chaque fichier et le reformate selon les templates AIDD dans `aidd_docs/` |
| `/custom:02:release_to_site` | Récupère une release GitHub et traduit les changements notables en contenu marketing sur le site |
| `/custom:03:site_section` | Planifie et implémente une section sur le site marketing (Nuxt + Vue + UnoCSS) |
| `/custom:08:changelog` | Génère ou met à jour `CHANGELOG.md` à partir de l'historique git, puis commit et tag la release |
| `/custom:08:end_plan` | Archive le plan en cours, exécute `/learn`, retourne sur la branche parente et nettoie |

## Agents

| Agent | Description |
|---|---|
| `ada` | Agent d'apprentissage interactif — quiz sur le codebase et la memory bank. Se déclenche avec "quiz me", "test my knowledge", "learn the codebase" ou "Ada" |

## Règles

| Règle | Description |
|---|---|
| `04-agentic-tooling` | Pratiques de tooling agentique issues de l'Agentic Readiness Framework (Principe 3) |
| `04-git-main-protection` | Interdit tout `git commit` ou `git push` sur `main` sans validation explicite de l'utilisateur |
| `04-rules-namespace` | Convention de namespace pour les règles — toutes les règles projet vont dans `custom/`, le core AIDD ne doit pas être modifié |
| `06-agentic-tests` | Pratiques de tests agentiques issues de l'Agentic Readiness Framework (Principe 1) |
| `07-agentic-type-safety` | Pratiques de typage agentique issues de l'Agentic Readiness Framework (Principe 2) |
| `08-agentic-branching` | Pratiques de branching agentique issues de l'Agentic Readiness Framework |
| `09-aidd-workflow` | Workflow AIDD de la conception à l'implémentation — s'applique à toute demande touchant au comportement ou à la structure du code |

## Templates (`aidd_docs/`)

Les fichiers du dossier `templates/custom/` sont copiés dans `aidd_docs/` du projet cible :

| Template | Description |
|---|---|
| `agentic_readiness_framework.md` | Framework d'évaluation de la maturité agentique du projet |
| `architecture_summary.md` | Résumé de l'architecture technique du projet |
| `audit_score.md` | Grille de scoring pour l'audit agentique |
| `quiz_report.md` | Rapport de session de quiz Ada — score et résultats par session |

## Installation

Cloner ce dépôt dans le dossier `.claude/` de votre projet :

```bash
git clone <repo-url> .claude/commands/custom
```

Ou ajouter comme sous-module git :

```bash
git submodule add <repo-url> .claude/commands/custom
```

Copier ensuite les templates dans `aidd_docs/` :

```bash
cp .claude/commands/custom/templates/custom/* aidd_docs/
```

Les commandes seront accessibles dans Claude Code via `/custom:01:migrate_docs`, `/custom:08:changelog`, etc.

## Prérequis

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code)
- [AIDD](https://github.com/ai-driven-dev/aidd-framework) configuré dans le projet cible
- `gh` CLI pour les commandes interagissant avec GitHub
