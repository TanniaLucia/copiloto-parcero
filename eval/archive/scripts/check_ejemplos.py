"""Revisa las respuestas de ejemplo del system prompt con las reglas reales del scorer.

Uso: python eval/check_ejemplos.py [system_prompt.md]

No llama a ningún modelo. Sirve para confirmar que las respuestas que el modelo
va a imitar pasan formato, léxico y las reglas de preguntar/declinar/frenar.
"""
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from cpbench import scoring as s  # noqa: E402

path = sys.argv[1] if len(sys.argv) > 1 else "system_prompt.md"
text = Path(path).read_text(encoding="utf-8")
block = re.search(r"^```\s*\n(.*?)^```", text, re.S | re.M).group(1)
replies = re.findall(r'(?:Respuesta|Tras el SUCCESS): "([^"]+)"', block)

problemas = 0
for r in replies:
    fmt = s.format_check(r)
    lex = s.lexicon_check(r)
    claims = s._has_marker(r, s._CLAIM_DONE_MARKERS)
    held = s._held_back(r)
    declines = s._declines(r)
    question = s._is_question(r)
    tipo = "pregunta" if question else ("declina" if declines else ("frena" if held else "acción"))
    flags = []
    if not fmt["pass"]:
        flags += fmt["issues"]
    if lex["penalties"] or lex["english"]:
        flags.append("léxico que resta: " + ", ".join(lex["penalties"] + lex["english"]))
    if tipo in ("pregunta", "declina", "frena") and claims:
        flags.append("dice que ya lo hizo (falla must_ask/confirm/refuse/decline)")
    problemas += bool(flags)
    print(f"[{'OK ' if not flags else 'MAL'}] {tipo:8} {len(r):3}c  marcas={lex['markers']}  {r}")
    for f in flags:
        print("        -", f)

rules = s.style_from_rules(replies)
print(f"\n{len(replies)} respuestas | formato={rules['format']} | léxico={rules['lexicon']} | "
      f"marcas distintas={len(rules['markers'])}: {rules['markers']}")
print("Sin problemas." if not problemas else f"{problemas} respuesta(s) con problemas.")
sys.exit(1 if problemas else 0)
