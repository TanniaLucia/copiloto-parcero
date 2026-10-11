#!/usr/bin/env bash
# A/B local reproducible sobre los 9 casos usados para elegir la variante.
# 8 casos públicos (dev) + col-03 del dataset propio; no contacta el servidor oficial.
# Usa el modelo configurado en .env (por defecto, Qwen en Ollama local).
set -euo pipefail

python3 -m cpbench run \
  --set dev \
  --prompt eval/prompts/v4_textual_actions.md \
  --no-judge --runs 1 --concurrency 1 \
  --only dev-04,dev-05,dev-09,dev-11,dev-16,dev-18,dev-19,dev-20 \
  --json eval/local_v4_textual_8dev.json

python3 -m cpbench run \
  --set dev \
  --prompt eval/prompts/v4_tool_calls_internal.md \
  --no-judge --runs 1 --concurrency 1 \
  --only dev-04,dev-05,dev-09,dev-11,dev-16,dev-18,dev-19,dev-20 \
  --json eval/local_v4_tool_calls_8dev.json

python3 -m cpbench run \
  --set eval/casos_colombianos.jsonl \
  --prompt eval/prompts/v4_textual_actions.md \
  --no-judge --runs 1 --concurrency 1 \
  --only col-03 \
  --json eval/local_v4_textual_col03.json

python3 -m cpbench run \
  --set eval/casos_colombianos.jsonl \
  --prompt eval/prompts/v4_tool_calls_internal.md \
  --no-judge --runs 1 --concurrency 1 \
  --only col-03 \
  --json eval/local_v4_tool_calls_col03.json

python3 - <<'PY'
import json
import re
from pathlib import Path

cases_by_variant = {
    "Textual": [
        "eval/local_v4_textual_8dev.json",
        "eval/local_v4_textual_col03.json",
    ],
    "Llamadas exactas": [
        "eval/local_v4_tool_calls_8dev.json",
        "eval/local_v4_tool_calls_col03.json",
    ],
}
expected = {"dev-04", "dev-05", "dev-09", "dev-11", "dev-16", "dev-18", "dev-19", "dev-20", "col-03"}
leak_pattern = re.compile(r"\b(?:set|get)_[a-z_]+|`|\bSUCCESS\b|\bLlamas\b", re.I)
results = {}

for variant, files in cases_by_variant.items():
    cases = []
    for filename in files:
        data = json.loads(Path(filename).read_text(encoding="utf-8"))
        if data["summary"].get("tokens_total", 0) <= 0:
            raise SystemExit(f"{filename}: no hubo salida del modelo; comparación inválida.")
        cases.extend(data["cases"])
    ids = [case["id"] for case in cases]
    if set(ids) != expected or len(ids) != len(expected):
        raise SystemExit(f"{variant}: esperaba los 9 casos {sorted(expected)} y obtuvo {sorted(ids)}.")
    leaks = [(case["id"], reply) for case in cases for reply in case.get("replies", []) if leak_pattern.search(reply)]
    results[variant] = {case["id"]: case["pass"] for case in cases}
    passed = sum(results[variant].values())
    print(f"{variant}: {passed}/9; notación técnica en respuestas: {len(leaks)}")
    for case_id in sorted(expected):
        print(f"  {case_id}: {'PASA' if results[variant][case_id] else 'falla'}")
    if leaks:
        for case_id, reply in leaks:
            print(f"  FUGA {case_id}: {reply}")
        raise SystemExit(f"{variant}: hubo fuga de notación; revisa las respuestas antes de elegir.")

print("\nDiferencias:")
for case_id in sorted(expected):
    text_pass = results["Textual"][case_id]
    tools_pass = results["Llamadas exactas"][case_id]
    if text_pass != tools_pass:
        print(f"  {case_id}: {'llamadas exactas' if tools_pass else 'textual'} gana")
PY
