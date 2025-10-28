---
description: Valide automatiquement la cohérence de la memory bank Claude Code. S'active quand l'utilisateur mentionne "memory", "documentation", "context", ou demande /context. Détecte fichiers manquants, doublons, incohérences de tokens. Read-only, ne modifie jamais CLAUDE.md sans confirmation.
allowed-tools: [Read, Glob, Bash]
---

# Memory Bank Validator

## Déclencheurs

Utiliser cette skill quand l'utilisateur :
- Tape `/context` ou `/memory`
- Mentionne "memory bank", "documentation", "context usage"
- Demande "quels fichiers sont chargés ?"
- Parle d'incohérences dans la documentation
- Invoque `@agent-claude-code-optimizer`

## Workflow de Validation

### Étape 1 : Extraction des Références

```bash
# Lire CLAUDE.md et extraire toutes les lignes @documentation/
grep -E '^@documentation/' /home/tnn/Projets/SmartLockers/client-manager/CLAUDE.md
```

### Étape 2 : Vérification Existence

Pour chaque fichier référencé :

```bash
# Vérifier que le fichier existe
file="/home/tnn/Projets/SmartLockers/client-manager/documentation/architecture/README.md"
if [ -f "$file" ]; then
    echo "✅ $file"
else
    echo "❌ MANQUANT: $file"
fi
```

### Étape 3 : Détection Doublons

```bash
# Compter les occurrences de chaque référence
grep -E '^@documentation/' CLAUDE.md | sort | uniq -c | grep -v '^ *1 '
```

### Étape 4 : Estimation Tokens

```bash
# Compter les mots (approximation tokens ≈ words * 1.3)
wc -w documentation/architecture/README.md
```

Comparer avec l'estimation dans CLAUDE.md.

### Étape 5 : Fichiers Suggérés Manquants

Vérifier si les fichiers recommandés par `claude-code-optimizer` sont présents :

```bash
# Fichiers Priority 1 (CRITIQUES)
files=(
    "architecture/11-api-integration-patterns.md"
    "architecture/06-security-architecture.md"
    "architecture/client-configuration-schema.md"
)

for file in "${files[@]}"; do
    grep -q "@documentation/$file" CLAUDE.md || echo "⚠️ RECOMMANDÉ MANQUANT: $file"
done
```

## Format de Rapport

Produire un rapport concis :

```markdown
## 📊 Memory Bank Validation

**Statut** : ✅ Sain / ⚠️ Attention / ❌ Erreurs détectées

### Résumé
- Références dans CLAUDE.md : 11
- Fichiers valides : 11/11
- Fichiers manquants : 0
- Doublons : 0
- Fichiers recommandés manquants : 3

### ❌ Problèmes Détectés

*(Si aucun problème : "Aucun problème détecté")*

1. ❌ **Fichier manquant** : `architecture/missing-file.md` (ligne 42 de CLAUDE.md)
2. ⚠️ **Doublon** : `api/sync.md` référencé 2 fois (lignes 52 et 68)
3. ⚠️ **Taille incohérente** : `database-schema-complete.md` (estimé 10k, réel 13.7k)

### 💡 Améliorations Suggérées

1. **Ajouter** : `architecture/11-api-integration-patterns.md` (5.5k tokens)
   - Circuit breakers, retry patterns (utilisés partout dans le code)

2. **Ajouter** : `architecture/06-security-architecture.md` (5.7k tokens)
   - JWT validation, multi-tenant isolation (critique)

3. **Retirer doublon** : Ligne 68 de CLAUDE.md (`api/sync.md`)

### 🎯 Actions Recommandées

Voulez-vous que je :
- [ ] Mette à jour CLAUDE.md pour ajouter les fichiers manquants ?
- [ ] Retire les doublons détectés ?
- [ ] Affiche le contenu de `/check-memory` pour plus de détails ?
```

## Règles Strictes

1. **Read-only par défaut** : Ne JAMAIS modifier CLAUDE.md sans confirmation explicite
2. **Pas de faux positifs** : Vérifier l'existence réelle des fichiers
3. **Concis** : Rapport < 20 lignes sauf si problèmes détectés
4. **Actionnable** : Toujours proposer des actions concrètes

## Exemples d'Invocation

### Exemple 1 : Validation Proactive

```
User: /context
Assistant: [Invoque automatiquement memory-bank-validator]

📊 Memory Bank Validation: ✅ Sain
- 11/11 fichiers valides
- Aucun doublon
- 3 fichiers recommandés à ajouter (voir suggestions)
```

### Exemple 2 : Détection d'Erreur

```
User: Pourquoi Claude ne trouve pas les patterns d'intégration API ?
Assistant: [Invoque memory-bank-validator]

❌ Memory Bank Validation: Problème détecté
- architecture/11-api-integration-patterns.md NON CHARGÉ
- Ce fichier contient les circuit breakers dont vous avez besoin
- Voulez-vous que je l'ajoute à CLAUDE.md ?
```

## Supporting Files

**Ne lire ces fichiers QUE si nécessaire** (progressive disclosure) :

- `CLAUDE.md` : Toujours lire pour extraire les références
- `documentation/architecture/*.md` : Lire seulement pour vérifier existence
- `.claude/agents/*.md` : Lire si l'utilisateur demande validation des agents

## Performance

- Exécution cible : < 5 secondes
- Utiliser `grep` et `wc` (rapide) plutôt que lire tous les fichiers
- Ne calculer les tokens réels QUE si incohérence suspectée
