#!/usr/bin/env bash
set -euo pipefail

BASE_URL=${BACKEND_URL:-"https://etude8-bible-api-production.up.railway.app"}
echo "BASE_URL=$BASE_URL"

# ---------- Sanity /health ----------
echo "== /api/health =="
hstatus=$(curl -s "$BASE_URL/api/health" | jq -r '.status')
test "$hstatus" = "ok" || { echo "Health NOK"; exit 1; }
echo "Health OK"

# ---------- Non progressif : 31 versets ----------
echo "== generate-verse-by-verse : compte des versets =="
count=$(curl -s -X POST "$BASE_URL/api/generate-verse-by-verse" \
  -H "Content-Type: application/json" \
  -d '{"passage":"Genese 1","enriched":true,"target_chars":1500}' \
  | jq -r '.content' | grep -oE '^VERSET [0-9]+$' | wc -l)
echo "Versets comptés: $count"
test "$count" -eq 31 || { echo "Attendu 31 versets"; exit 1; }

# ---------- Progressif : présence des clés ----------
echo "== generate-verse-by-verse-progressive : clés attendues =="
resp=$(curl -s -X POST "$BASE_URL/api/generate-verse-by-verse-progressive" \
  -H "Content-Type: application/json" \
  -d '{"passage":"Genese 1","batch_size":5,"start_verse":11,"enriched":true,"target_chars":2500}')
echo "$resp" | jq .

vr=$(echo "$resp" | jq -r '.verse_range')
bm=$(echo "$resp" | jq -r '.batch_content' | wc -c)
tm=$(echo "$resp" | jq -r '.verse_stats.total')
pm=$(echo "$resp" | jq -r '.verse_stats.processed')

test "$vr" = "11-15" || { echo "verse_range attendu 11-15"; exit 1; }
test "$bm" -gt 0 || { echo "batch_content vide"; exit 1; }
test "$tm" -eq 31 || { echo "total attendu 31"; exit 1; }
test "$pm" -ge 15 || { echo "processed attendu ≥ 15"; exit 1; }

echo "✅ Assertions OK"
