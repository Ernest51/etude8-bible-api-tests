# Tests API Étude 8 Bible

## Prérequis
- `curl`, `jq`
- Python 3 (pour `per_verse_stats.py`)

## Lancer les tests rapides

### Sans export global (recommandé)
```bash
BACKEND_URL=https://etude8-bible-api-production.up.railway.app ./tests_cli.sh
