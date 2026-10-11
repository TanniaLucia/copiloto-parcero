#!/usr/bin/env bash
# Compara v0 (línea base), v1 y v4 (system_prompt.md) en los mismos casos con el modelo local.
# Uso: bash eval/ab_rapido.sh            (casos por defecto)
#      bash eval/ab_rapido.sh dev-01,dev-14,dev-20
CASOS="${1:-dev-01,dev-11,dev-19}"
SALIDA="eval/ab_rapido_resultado.txt"
: > "$SALIDA"
for P in eval/prompts/v0_baseline.md eval/prompts/v1_system_prompt.md system_prompt.md; do
  echo "==================== $P ====================" | tee -a "$SALIDA"
  python3 -m cpbench run --set dev --prompt "$P" --no-judge --only "$CASOS" 2>&1 | tee -a "$SALIDA"
done
echo "Resultado guardado en $SALIDA"
