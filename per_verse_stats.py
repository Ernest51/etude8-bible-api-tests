#!/usr/bin/env python3
# per_verse_stats.py — calcule la taille de chaque VERSET dans une réponse API

import sys, re

text = sys.stdin.read()
# Découpe sur les lignes "VERSET n"
blocks = re.split(r'(?m)^VERSET \d+\s*$', text)
matches = re.findall(r'(?m)^VERSET (\d+)\s*$', text)

for i, verse_num in enumerate(matches):
    block = blocks[i+1].strip() if i+1 < len(blocks) else ""
    print(f"VERSET {verse_num}: {len(block)} caractères")
