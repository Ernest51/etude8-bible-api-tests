#!/usr/bin/env bash
set -e

BASE_URL=${BACKEND_URL:-"https://etude8-bible-api-production.up.railway.app"}

echo "=== /api/health ==="
curl -s "$BASE_URL/api/health" | jq

echo -e "\n=== Genèse 1 (enriched=true, target_chars=1500) — compte des VERSETs ==="
curl -s -X POST "$BASE_URL/api/generate-verse-by-verse" \
  -H "Content-Type: application/json" \
  -d '{"passage":"Genese 1","enriched":true,"target_chars":1500}' \
  | jq -r '.content' | grep -oE '^VERSET [0-9]+$' | wc -l

echo -e "\n=== Progressif 6-10 (target_chars=2500) ==="
curl -s -X POST "$BASE_URL/api/generate-verse-by-verse-progressive" \
  -H "Content-Type: application/json" \
  -d '{"passage":"Genese 1","batch_size":5,"start_verse":6,"enriched":true,"target_chars":2500}' \
  | jq
