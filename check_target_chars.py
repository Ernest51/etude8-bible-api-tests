#!/usr/bin/env python3
import sys, json, re

if len(sys.argv) < 2:
    print("Usage: check_target_chars.py <target> [tolerance_pct]", file=sys.stderr)
    sys.exit(2)

target = int(sys.argv[1])
tol_pct = int(sys.argv[2]) if len(sys.argv) > 2 else 30  # tolérance ±30%

data = sys.stdin.read()
try:
    content = json.loads(data).get("content","")
except json.JSONDecodeError:
    content = data

n = len(content)
low = int(target * (100 - tol_pct)/100)
high = int(target * (100 + tol_pct)/100)

print(f"content_length={n} (target={target}, tol=±{tol_pct}%) -> attendu [{low}..{high}]")
if not (low <= n <= high):
    print("❌ Hors tolérance")
    sys.exit(1)
print("✅ OK")
