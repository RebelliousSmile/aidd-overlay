# Check Memory Bank Consistency

Vérifier la cohérence et l'intégrité de la memory bank Claude Code.

## Objectif

Détecter automatiquement :
- Fichiers référencés mais manquants
- Doublons dans CLAUDE.md
- Incohérences entre taille estimée et réelle
- Opportunités d'optimisation

## Actions à Exécuter

### 1. Analyser CLAUDE.md

Lire `/home/tnn/Projets/SmartLockers/client-manager/CLAUDE.md` et extraire toutes les références `@documentation/...`.

### 2. Vérifier l'Existence

Pour chaque fichier référencé, vérifier qu'il existe sur le disque.

### 3. Détecter les Doublons

Identifier les fichiers référencés plusieurs fois.

### 4. Estimer les Tokens

Comparer les estimations de tokens dans les commentaires vs la taille réelle des fichiers.

### 5. Suggérer des Améliorations

Basé sur les recommandations de `claude-code-optimizer`, suggérer des fichiers à ajouter ou retirer.

## Format de Sortie

Produire un rapport structuré :

```markdown
## 📊 Memory Bank Health Check

**Date** : 2025-10-24
**Fichiers analysés** : X références dans CLAUDE.md

### ✅ Statut Global

- Fichiers valides : X/X
- Fichiers manquants : 0
- Doublons détectés : 0
- Incohérences : 0

### 📁 Fichiers Chargés

1. ✅ CLAUDE.md (4.0k tokens estimés, 4.2k réels)
2. ✅ architecture/README.md (1.5k tokens estimés, 1.6k réels)
3. ❌ **MANQUANT** : architecture/11-api-integration-patterns.md
4. ⚠️ **DOUBLON** : api/sync.md (référencé 2 fois lignes 42 et 58)

### 💡 Recommandations

1. **Ajouter** : architecture/11-api-integration-patterns.md (5.5k tokens)
2. **Ajouter** : architecture/06-security-architecture.md (5.7k tokens)
3. **Retirer doublon** : api/sync.md ligne 58
4. **Total après optimisation** : 67.8k tokens (34% du contexte)

### 🎯 Actions Suggérées

- [ ] Décommenter `@documentation/architecture/11-api-integration-patterns.md`
- [ ] Décommenter `@documentation/architecture/06-security-architecture.md`
- [ ] Retirer ligne 58 (doublon api/sync.md)
- [ ] Relancer `/check-memory` pour validation
```

## Notes

- Utiliser `Read` pour lire CLAUDE.md
- Utiliser `Bash` pour `file_exists` ou `wc -w`
- Utiliser `Glob` pour lister les fichiers documentation/
- Ne PAS modifier CLAUDE.md automatiquement (demander confirmation)
