# AGENTS.md

Instrucciones para el agente de IA que abra este repositorio (Claude Code, Cursor, Codex, Copilot, Gemini). Se cargan solas: no hay que pegar nada en ningun chat.

## Que es este repositorio

Es el codigo base de un reto de aprendizaje de Pragma: **Implementación de persistencia local y sincronización en modo offline**.

| | |
|---|---|
| Tema | Persistencia local y modo offline |
| Nivel | senior-l2 |
| Chapter | Móvil |
| Especialidad | Flutter |
| Stack | Dart 3.6 / Flutter 3.27 |
| Patron arquitectonico | clean_architecture_mvvm |
| Tiempo estimado | 1 semana |

## Tu tarea

Dejar este proyecto en estado **verificable**: que el comando de verificacion corra sin errores. Escribi los archivos en disco, en este repositorio. No generes ZIPs ni archivos adjuntos.

En orden:

1. Corre `flutter pub get && flutter analyze` y mira que falla.
2. Completa lo que falte de la lista de abajo: manifiesto de dependencias, punto de entrada, capa de interfaz y las capas del patron declarado.
3. Arregla SOLO los errores que impiden compilar o arrancar.
4. Volve a correr `flutter pub get && flutter analyze` hasta que pase.
5. Pará ahí.

## Regla dura: las fases son trabajo del humano

**PROHIBIDO implementar los entregables de las fases.** El valor del reto esta en que la persona los resuelva. Tu trabajo es que tenga un proyecto que arranca; el hueco pedagogico se queda como esta.

No resuelvas nada de esto:

- **Fase 1 — Exploración del problema y diseño de la solución**: Documento de diseño que describe la estrategia de persistencia local y sincronización.
- **Fase 2 — Implementación de la persistencia local**: Código que implementa la persistencia local de las transacciones.
- **Fase 3 — Implementación de la sincronización con el servidor**: Código que implementa la sincronización de las transacciones locales con el servidor.

Distincion operativa:

- **Arreglar** (si): import faltante, tipo que no existe, dependencia sin declarar, error de sintaxis, archivo referenciado que no existe.
- **No tocar** (no): logica de negocio incompleta, validaciones ausentes, secretos hardcodeados, APIs deprecadas que funcionan, concurrencia insegura, patrones mejorables. Eso es lo que la persona tiene que encontrar.

## Lo que falta y tenes que completar

### 1. Boilerplate del stack (1)

Sin esto el proyecto no compila ni arranca. **Es tu trabajo crearlo**, y no toca nada de lo pedagogico: es andamiaje del stack.

- [ ] **android/app/src/main/AndroidManifest.xml** — Sin el manifest embebido de Android, flutter build/run no tiene target de plataforma y no puede empaquetar el APK.

### 2. Archivos que la arquitectura declara (1 de 27)

La propuesta arquitectonica del reto los lista y no llegaron al repo. Crealos con implementacion real, respetando la capa en la que viven:

- [ ] `lib/presentation/widgets/sync_status_indicator.dart`

### Presentes (26)

- `pubspec.yaml`
- `lib/main.dart`
- `lib/core/error/failures.dart`
- `lib/core/error/exceptions.dart`
- `lib/core/network/network_info.dart`
- `lib/core/constants/app_constants.dart`
- `lib/core/database/app_database.dart`
- `lib/domain/entities/transaction.dart`
- `lib/domain/repositories/transaction_repository.dart`
- `lib/domain/usecases/save_transaction.dart`
- `lib/domain/usecases/get_pending_transactions.dart`
- `lib/domain/usecases/sync_transactions.dart`
- `lib/domain/usecases/get_all_transactions.dart`
- `lib/data/models/transaction_model.dart`
- `lib/data/datasources/local/transaction_local_datasource.dart`
- `lib/data/datasources/remote/transaction_remote_datasource.dart`
- `lib/data/repositories/transaction_repository_impl.dart`
- `test/domain/usecases/save_transaction_test.dart`
- `lib/presentation/bloc/transaction_event.dart`
- `lib/presentation/bloc/transaction_state.dart`
- `lib/presentation/bloc/transaction_bloc.dart`
- `lib/presentation/screens/home_screen.dart`
- `lib/presentation/screens/add_transaction_screen.dart`
- `lib/presentation/widgets/transaction_item.dart`
- `lib/injection_container.dart`
- `test/data/repositories/transaction_repository_impl_test.dart`

### Capas del patron declarado

Cada una tiene que existir como directorio real con al menos un archivo. Codigo plano en la raiz no satisface el patron.

- `lib/core/error`
- `lib/core/network`
- `lib/core/constants`
- `lib/core/database`
- `lib/domain/entities`
- `lib/domain/repositories`
- `lib/domain/usecases`
- `lib/data/models`
- `lib/data/datasources/local`
- `lib/data/datasources/remote`
- `lib/data/repositories`
- `lib/presentation/bloc`
- `lib/presentation/screens`
- `lib/presentation/widgets`
- `test/domain`
- `test/data`

## Verificacion

```bash
flutter pub get && flutter analyze
```

Ese comando pasando es la definicion de "terminado" para vos.

## Convenciones que tenes que respetar

- Un solo ecosistema: no declares librerias de otro lenguaje ni mezcles gestores de paquetes.
- Toda libreria que uses tiene que estar declarada en el manifiesto de dependencias.
- Todo import declarado tiene que usarse; todo tipo usado tiene que existir o venir de una dependencia declarada.
- El patron es **clean_architecture_mvvm**: los contratos (interfaces, puertos) los define la capa interna y los implementa la externa, nunca al revés.
- Los archivos que crees llevan implementacion real, no stubs: sin `TODO`, sin cuerpos vacios, sin `// getters y setters`.

## Contexto del candidato

Sirve para calibrar el nivel del codigo, no para resolver las fases.

- Perfil: Chapter Movil, Especialidad Desarrollador, Tecnología Flutter, Senior
- Brecha que el reto ataca: Maneja estado y flujos asincronicos con persistencia local y sincronizacion posterior
- Mision: Soportar operacion sin conexion en la app de pagos

---

*Generado por Challenge Generator — Pragma. `README.md` tiene el enunciado completo del reto para la persona. `PROMPT_MEJORA.md` es la variante para pegar en un chat, si se prefiere ese flujo.*
