# Implementación de persistencia local y sincronización en modo offline

La aplicación de pagos de nuestra empresa debe soportar operaciones sin conexión. Los usuarios deben poder realizar transacciones y estas se deben almacenar localmente hasta que la conexión se restablezca y se puedan sincronizar con el servidor. Los actores involucrados son el usuario, la aplicación de pagos y el servidor de backend. La aplicación debe manejar flujos asincrónicos y persistir el estado localmente para asegurar que las transacciones se completen correctamente una vez que la conexión se restablezca. La aplicación debe ser capaz de manejar hasta 100 transacciones sin conexión antes de sincronizar con el servidor.

## Informacion General

| Campo | Valor |
|-------|-------|
| **Tema** | Persistencia local y modo offline |
| **Nivel** | senior-l2 |
| **Tipo** | practical |
| **Tiempo estimado** | 1 semana |

## Fases del Reto

### Fase 0: Configuración del Proyecto

**Objetivo:** Obtener el proyecto base funcional enviando el Código Base a un asistente de IA, que lo analizará, corregirá errores y generará un ZIP listo para usar.

**Tiempo estimado:** 15-30 minutos

**Instrucciones:**

- Asegúrate de tener instalado para ejecutar el proyecto: Un IDE o editor de código.
- Copia todo el contenido del campo **Código Base** de este reto — incluyendo el texto de instrucciones que aparece al inicio.
- Abre un asistente de IA (Claude en claude.ai, ChatGPT o Gemini — se recomienda Claude), pega el contenido copiado en el chat y envíalo.
- El asistente analizará los archivos, corregirá errores y generará un archivo ZIP descargable. Descárgalo y extráelo en la carpeta donde quieras trabajar.
- Verifica que el proyecto arranca sin errores.

**Entregable:** El proyecto compila/arranca sin errores.

<details>
<summary>Pistas de conocimiento</summary>

- Copia el Código Base completo incluyendo el texto de instrucciones al inicio — esas instrucciones le indican al asistente exactamente qué hacer con los archivos.
- Si el asistente no genera el ZIP automáticamente al terminar el análisis, escríbele: "genera el ZIP ahora".
- Si el proyecto tiene errores al arrancar, comparte el mensaje de error con el mismo asistente para que lo corrija.

</details>

### Fase 1: Exploración del problema y diseño de la solución

**Objetivo:** Identificar los requisitos y diseñar una solución que permita la persistencia local y la sincronización posterior.

**Tiempo estimado:** 2 días

**Instrucciones:**

- Analiza las necesidades de la aplicación para soportar operaciones sin conexión.
- Diseña una estrategia para persistir las transacciones localmente y sincronizarlas con el servidor una vez que la conexión se restablezca.

**Entregable:** Documento de diseño que describe la estrategia de persistencia local y sincronización.

<details>
<summary>Pistas de conocimiento</summary>

- Considera los diferentes estados de la conexión y cómo manejarlos.
- Piensa en cómo asegurar la consistencia de los datos entre la aplicación local y el servidor.

</details>

### Fase 2: Implementación de la persistencia local

**Objetivo:** Implementar la persistencia local de las transacciones para soportar operaciones sin conexión.

**Tiempo estimado:** 3 días

**Instrucciones:**

- Implementa la lógica para persistir las transacciones localmente cuando la aplicación está sin conexión.
- Asegura que las transacciones se almacenen de manera segura y se puedan recuperar correctamente.

**Entregable:** Código que implementa la persistencia local de las transacciones.

<details>
<summary>Pistas de conocimiento</summary>

- Utiliza una base de datos local para almacenar las transacciones.
- Considera la seguridad y la eficiencia al almacenar y recuperar las transacciones.

</details>

### Fase 3: Implementación de la sincronización con el servidor

**Objetivo:** Implementar la lógica para sincronizar las transacciones locales con el servidor una vez que la conexión se restablezca.

**Tiempo estimado:** 2 días

**Instrucciones:**

- Implementa la lógica para sincronizar las transacciones locales con el servidor una vez que la conexión se restablezca.
- Asegura que las transacciones se envíen al servidor en el orden correcto y que se maneje correctamente cualquier error de sincronización.

**Entregable:** Código que implementa la sincronización de las transacciones locales con el servidor.

<details>
<summary>Pistas de conocimiento</summary>

- Considera el orden de las transacciones y cómo manejar los errores de sincronización.
- Piensa en cómo asegurar la consistencia de los datos entre la aplicación local y el servidor.

</details>

## Dimensiones Evaluadas

- **queEs**: ¿Qué es la persistencia local y por qué es importante en una aplicación de pagos?
- **paraQueSirve**: ¿Para qué sirve la sincronización de transacciones en una aplicación de pagos?
- **comoSeUsa**: ¿Cómo se usa la persistencia local y la sincronización en una aplicación de pagos?
- **erroresComunes**: ¿Cuáles son los errores comunes al implementar la persistencia local y la sincronización?
- **queDecisionesImplica**: ¿Qué decisiones implica la implementación de la persistencia local y la sincronización en una aplicación de pagos?

## Criterios de Evaluacion

- Identificar los requisitos para soportar operaciones sin conexión.
- Diseñar una estrategia para persistir las transacciones localmente y sincronizarlas con el servidor.
- Implementar la persistencia local de las transacciones.
- Implementar la sincronización de las transacciones locales con el servidor.

## Como trabajar con un asistente de IA

Hay dos caminos, elegi uno:

- **AGENTS.md** (recomendado) — instrucciones nativas del repo. Abri esta carpeta con tu agente local (Claude Code, Cursor, Codex, Copilot, Gemini) y las carga solo. Sabe que archivos faltan y con que comando se verifica, y completa el scaffold escribiendo en disco.
- **PROMPT_MEJORA.md** — para copiar y pegar en un chat (claude.ai, ChatGPT). Devuelve un ZIP con el proyecto. Sirve si no tenes un agente en el IDE.

Ninguno de los dos resuelve las fases del reto: eso es tu trabajo.

## Verificacion

El proyecto esta listo para trabajar cuando este comando corre sin errores:

```bash
flutter pub get && flutter analyze
```

---

*Reto generado automaticamente por Challenge Generator - Pragma*
