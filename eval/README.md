# Casos propios

`casos_colombianos.jsonl` reúne 20 casos exploratorios escritos para probar paráfrasis y situaciones en español colombiano. Es un conjunto de **evaluación**, no de entrenamiento. Su creación permitió revisar cobertura lingüística sin modificar el modelo fijo del reto.

Desde la raíz del repositorio, con `cpbench` y un modelo local configurados, puedes correrlos así:

```bash
python3 -m cpbench run --set eval/casos_colombianos.jsonl --prompt system_prompt.md
```

La corrida exploratoria v7 con Qwen2.5-16k pasó 4/20. No es comparable con los resultados oficiales ni corresponde a una evaluación local de v12. El [resumen de resultados](RESULTADOS.md) explica las diferencias entre versiones y modelos.
