# Copiloto Parcero

Asistente de voz para un vehículo simulado, evaluado en español colombiano. Esta entrega mejora el `system_prompt.md` del reto **AI and Autonomous Driving Research at THI**; el modelo y las herramientas permanecen fijos.

## Entrega

| | |
| --- | --- |
| **Equipo registrado** | `ParceroA` |
| **Integrante** | Tannia Lucia Hernandez |
| **Cohorte** | COH1 |
| **Modelo de evaluación** | `openai/gpt-oss-120b` |
| **Último envío aceptado al set oculto** | **66,4/100** — 20/32 tareas; voz 82/100 |
| **Último resultado limpio en el set público** | **97,6/100** — 20/20 tareas; voz 88/100 |
| **Video de presentación (inglés)** | [Ver video en Google Drive](https://drive.google.com/drive/folders/1VANEKWuiIcr52mCAtCyKcLmrZJyzjs3g) |

La clave del servidor no se incluye en el repositorio.

## Decisión de diseño

La versión final es **v12**, guardada en [system_prompt.md](system_prompt.md). En v4, el asistente omitió un paso necesario al desempañar el parabrisas. Probamos después v11, que agrupaba varios cambios: mejoró el set público, pero bajó en el oculto. Volvimos a v4 y en v12 aislamos el ajuste de desempañado: especificar el estado final del vehículo, completar las cuatro acciones necesarias y verificar antes de confirmar. El puntaje oculto subió de 63,9 a 66,4.

| Versión | Set público | Set oculto | Lectura |
| --- | --- | --- | --- |
| v4 | 93,6; 19/20 | 63,9; 19/32 | Base de comparación |
| v11 | 97,6; 20/20 | 56,4; 16/32 | La mejora pública no generalizó |
| **v12** | **97,6; 20/20** | **66,4; 20/32** | **Mejor resultado oculto; versión entregada** |

Los resultados y el desglose por categoría están en [eval/RESULTADOS.md](eval/RESULTADOS.md). En el set oculto, v12 fue más fuerte en peticiones de un paso (8/8); quedan oportunidades en varios pasos (3/8), ambiguas (5/8) e inseguras o imposibles (4/8).

## Español colombiano y datos

Consideré conjuntos de voz y pronunciación de Hugging Face —`ylacombe/google-colombian-spanish`, `bookbot/slr72_dataset` y Common Voice en español filtrado por Colombia—, pero no los usé para entrenar ni ajustar el modelo. El reto fija el modelo y evalúa texto y llamadas a herramientas; TTS y ASR no formaban parte de esa evaluación.

En cambio, preparé [20 casos propios](eval/casos_colombianos.jsonl) con paráfrasis y situaciones expresadas en español colombiano. Sirvieron para explorar comprensión y encontrar huecos, no para entrenar el sistema. Una corrida exploratoria v7 con Qwen2.5-16k pasó 4/20; al usar otro modelo y otra mezcla de casos, no predice el puntaje oficial.

La voz final obtuvo 82/100 en el set oculto: el juez dio 70 y las comprobaciones automáticas de léxico y formato, 100. La guía busca un tono cálido y natural con expresiones moderadas, sin convertir el acento en caricatura.

## Archivos de la entrega

- [Prompt final](system_prompt.md)
- [Reflexión](REFLEXION.md)
- [Registro de uso de IA](AI_LOG.md)
- [Resultados y decisiones](eval/RESULTADOS.md)
- [Casos propios y cómo correrlos](eval/README.md)

Codex apoyó la lectura de las reglas, el análisis de fallos y la comparación entre versiones, además de ayudar a preparar la documentación. Yo definí el objetivo, revisé los resultados y decidí conservar v12. El [registro de IA](AI_LOG.md) y la [reflexión](REFLEXION.md) detallan también dónde una recomendación de IA fue equivocada y cómo se corrigió el proceso.

## Créditos

Reto y herramientas del HCIS Lab, Technische Hochschule Ingolstadt, para la gira académica THI en Colombia, 2026. Código bajo licencia MIT; ver [LICENSE](LICENSE).
