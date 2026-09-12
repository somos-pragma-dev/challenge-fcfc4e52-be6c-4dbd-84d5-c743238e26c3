# Prompt para Mejorar el Codigo Base

Copia y pega el contenido del bloque de abajo en un asistente de IA (Claude, ChatGPT)
para obtener un ZIP con el proyecto completo y arrancable.

Si preferis trabajar en tu editor con un agente local (Claude Code, Cursor, Copilot), usa `AGENTS.md` en vez de este archivo: dice lo mismo pero para que escriba los archivos en disco.

## Las dos reglas que no se negocian

1. **Completa el boilerplate.** Todo lo que el proyecto necesita para compilar y arrancar: manifiesto de dependencias, punto de entrada, configuracion, capa de interfaz, y las capas del patron arquitectonico declarado. Eso es andamiaje y es tu trabajo.
2. **NO resuelvas el reto.** Los entregables de las fases son el trabajo de la persona. El hueco pedagogico se deja como esta: el proyecto arranca, pero lo que el reto pide implementar NO esta implementado.

Dicho de otra forma: si algo impide compilar, arreglalo. Si algo es logica de negocio incompleta, validaciones ausentes, un secreto hardcodeado o un patron mejorable, dejalo exactamente como esta — es lo que la persona tiene que encontrar.

## Lo que le falta a este proyecto

Esto NO lo tenes que adivinar: salio de comparar el proyecto contra la arquitectura declarada del reto y de un analisis estatico del codigo. Completalo TODO.

### Boilerplate del stack que falta

Sin esto no compila ni arranca. Es andamiaje, no toca nada de lo pedagogico:

- **android/app/src/main/AndroidManifest.xml** — Sin el manifest embebido de Android, flutter build/run no tiene target de plataforma y no puede empaquetar el APK.

### Archivos que la arquitectura del reto declara y no estan

Creálos con implementacion real, en la capa que les corresponde:

- `lib/presentation/widgets/sync_status_indicator.dart`

## Como saber que terminaste

```bash
flutter pub get && flutter analyze
```

Ese comando corriendo sin errores es la definicion de "listo".

---

```
## Briefing del reto (autoridad)
Este bloque manda sobre los archivos adjuntos. El stack y el rol salen de AQUÍ, no de un topic genérico ni de markdown placeholder.

### Perfil
Chapter Movil, Especialidad Desarrollador, Tecnología Flutter, Senior

### Brecha de conocimiento
Maneja estado y flujos asincronicos con persistencia local y sincronizacion posterior

### Misión / candidato
Soportar operacion sin conexion en la app de pagos

### Reto
- Tema: Persistencia local y modo offline
- Seniority: senior-l2
- Tipo: practical
- Título: Implementación de persistencia local y sincronización en modo offline
- Tiempo estimado: 1 semana

### Fases (trabajo del HUMANO — PROHIBIDO completarlas)
No implementes estos entregables. Dejalos como hueco pedagógico. El asistente solo materializa el proyecto arrancable para que el participante pueda trabajar.
- Fase 1: Exploración del problema y diseño de la solución — objetivo: Identificar los requisitos y diseñar una solución que permita la persistencia local y la sincronización posterior. — entregable (NO resolver): Documento de diseño que describe la estrategia de persistencia local y sincronización.
- Fase 2: Implementación de la persistencia local — objetivo: Implementar la persistencia local de las transacciones para soportar operaciones sin conexión. — entregable (NO resolver): Código que implementa la persistencia local de las transacciones.
- Fase 3: Implementación de la sincronización con el servidor — objetivo: Implementar la lógica para sincronizar las transacciones locales con el servidor una vez que la conexión se restablezca. — entregable (NO resolver): Código que implementa la sincronización de las transacciones locales con el servidor.

Eres un asistente experto en análisis, corrección y generación de archivos de cualquier tipo:
código fuente, documentación, hojas de cálculo, documentos Word, configuraciones, entre otros.
Voy a enviarte una cadena de texto que contiene uno o más archivos. Cada archivo está delimitado por un marcador con el siguiente formato:
// === ARCHIVO: ruta/del/archivo.extension ===
o también puede aparecer como:
## === ARCHIVO: ruta/del/archivo.extension ===
Lo que sigue al marcador puede ser:

El contenido real del archivo (código, texto, YAML, etc.)
Una descripción en lenguaje natural de lo que debe contener el archivo


TU TAREA
PASO 0 — ¿Esto es un proyecto o una carcasa?
Antes de extraer archivos, leé el Briefing (si está) y diagnosticá el adjunto.

Es CARCASA si ocurre CUALQUIERA de estas:
- No hay manifiesto de dependencias del stack del briefing (manifest.json de VTEX IO / package.json / pom.xml / build.gradle / requirements.txt / go.mod / *.tf / *.csproj, según corresponda)
- Hay un "binario" que en realidad es un comentario ("no puede ser mostrado como texto plano", placeholder .fig/.docx vacío)
- Los markdowns ya completan entregables de fases posteriores ("se implementó fade-in", lista de áreas ya resuelta)

Si es CARCASA:
- MATERIALIZÁ un proyecto que arranca en el stack del briefing (VTEX IO Store Framework, Angular, Terraform, pytest, Nest, etc.). Incluí manifiesto, punto de entrada y capa de interfaz reales.
- NO copies los markdowns de "solución" como si fueran el producto. Son ruido de generación.
- NO resuelvas las fases del briefing (están marcadas PROHIBIDO). Dejá el hueco pedagógico: el flujo existe, las microinteracciones/calidad/infra que el reto pide NO están hechas.
- Después seguí al PASO 5 (ZIP).

Si es un proyecto REAL (manifiesto + código que compila o arranca):
- Seguí PASO 1 en adelante. 🔴 compilación sí. 🟡 pedagógico no.

PASO 1 — Detección y extracción
Identifica todos los archivos presentes en la cadena. Para cada archivo extrae:

Su ruta completa (ej: src/main/java/com/pragma/Service.java)
Su contenido o descripción

PASO 2 — Clasificación por tipo
Clasifica cada archivo en una de estas categorías:
A) Código fuente (Java, Python, TypeScript, JavaScript, Kotlin, etc.)
B) Configuración / documentación (YAML, properties, Markdown, JSON, txt, etc.)
C) Excel (.xlsx, .xls, .csv)
D) Word (.docx, .doc)
E) Otro tipo de archivo binario o especial
PASO 3 — Clasificación de errores en código fuente

Objetivo prioritario: que el proyecto compile. No corrijas flujo de negocio ni lógica funcional.

Antes de modificar cualquier archivo de código fuente, clasifica cada problema encontrado en una de estas dos categorías:
🔴 ERROR DE COMPILACIÓN — corregir siempre
Son errores que impiden que el proyecto arranque, sin valor pedagógico:

Import faltante o incorrecto
Clase, método o variable referenciada que no existe en ningún archivo del proyecto
Error de sintaxis
Anotación con atributos inválidos
Dependencia ausente en pom.xml, package.json, etc.
Archivo referenciado que no existe y debe ser creado con implementación mínima

→ CORREGIR estos errores.
🟡 PROBLEMA FUNCIONAL O DE CALIDAD — preservar siempre
Son problemas que no impiden compilar. Pueden ser intencionales para el aprendizaje:

Clave secreta hardcodeada ("secret", "password123")
API deprecada que funciona pero tiene reemplazo moderno
Lógica de negocio incorrecta o incompleta
Código redundante o de baja legibilidad
Falta de validaciones en flujo de negocio
Patrones de diseño incorrectos pero funcionales
Concurrencia no segura
Configuración funcional pero no óptima

→ PRESERVAR tal cual. No corregir, no mejorar, no comentar.
PASO 4 — Procesamiento según tipo de archivo
Tipo A — Código fuente
Aplica únicamente las correcciones clasificadas como 🔴 ERROR DE COMPILACIÓN.
No alteres ningún elemento clasificado como 🟡 PROBLEMA FUNCIONAL O DE CALIDAD.
Si falta un archivo referenciado, créalo con la implementación mínima necesaria para compilar.
Tipo B — Configuración / documentación
Extrae el contenido tal cual, sin modificaciones salvo errores evidentes de sintaxis
(ej: YAML mal indentado).
Tipo C — Excel (.xlsx)
Si viene con contenido real, genera el archivo respetando ese contenido.
Si viene con descripción en lenguaje natural, genera un archivo Excel funcional con:

Fila de encabezados en negrita con color de fondo distintivo
Columnas con ancho ajustado al contenido
Tipos de dato correctos por columna
Validaciones si la descripción lo indica
Hojas nombradas descriptivamente si hay más de una
Filas de ejemplo si no hay datos reales

Tipo D — Word (.docx)
Si viene con contenido real, genera el archivo respetando ese contenido.
Si viene con descripción en lenguaje natural, genera un documento Word funcional con:

Estilos de título (Título 1, Título 2) para jerarquía de secciones
Fuente legible (Calibri o equivalente), tamaño 11-12pt para cuerpo
Márgenes estándar
Tabla de contenido si tiene múltiples secciones
Tablas con encabezados en negrita si aplica

Tipo E — Otro
Genera el archivo con el contenido o estructura más apropiada según la descripción.
PASO 5 — Exportación en ZIP
Empaqueta todos los archivos en un único archivo ZIP descargable respetando exactamente
la estructura de rutas indicada por los marcadores.
El ZIP debe incluir:

Archivos de código con únicamente los errores de compilación corregidos
Archivos de configuración y documentación sin cambios
Archivos nuevos creados para resolver dependencias de compilación faltantes
Archivos Excel y Word generados desde descripción

IMPORTANTE: El ZIP debe estar listo para descargar al finalizar. No preguntes si el usuario
quiere generarlo. Simplemente genera el archivo y proporciona el enlace de descarga; No debes desplegar en el chat el resumen de lo que arreglaste al Zip, solo entregalo.

REGLAS IMPORTANTES

No omitas ningún archivo aunque no tenga errores ni modificaciones
Respeta los nombres y rutas exactas indicadas por los marcadores
Si un archivo no tiene marcador claro, infiere el nombre desde su contenido
Si la cadena contiene solo documentación, placeholders o binarios fake, NO la reproduzcas:
aplicá PASO 0 (materializar el proyecto del briefing). Reproducir la carcasa es un fallo.
No agregues texto después del enlace de descarga del ZIP
No preguntes si el usuario quiere el ZIP: simplemente generalo siempre
Si detectas que falta un archivo de configuración necesario para compilar
(pom.xml, package.json, requirements.txt, build.gradle, etc.), créalo e inclúyelo
inferiendo su contenido desde los imports y frameworks detectados en el código
Nunca corrijas problemas 🟡 aunque parezcan obvios o fáciles de mejorar.
El participante que recibirá este proyecto los debe encontrar y resolver él mismo.


INPUT
Aquí está la cadena con los archivos:

// === ARCHIVO: pubspec.yaml ===
name: payment_app
description: A payment application with offline persistence and synchronization capabilities.
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.6.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.6.1
  drift: ^2.22.1
  sqlite3_flutter_libs: ^0.5.28
  path_provider: ^2.1.5
  path: ^1.9.1
  dio: ^5.7.0
  connectivity_plus: ^6.1.1
  get_it: ^8.0.3
  uuid: ^4.5.1
  equatable: ^2.0.7
  dartz: ^0.10.1
  flutter_secure_storage: ^9.2.4

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  drift_dev: ^2.22.1
  build_runner: ^2.4.14
  mockito: ^5.4.4
  riverpod_generator: ^2.6.3

flutter:
  uses-material-design: true

// === ARCHIVO: lib/main.dart ===
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/core/constants/app_constants.dart';
import 'package:payment_app/injection_container.dart' as di;
import 'package:payment_app/presentation/screens/home_screen.dart';
import 'package:payment_app/core/network/network_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const ProviderScope(child: PaymentApp()));
}

class PaymentApp extends ConsumerStatefulWidget {
  const PaymentApp({super.key});

  @override
  ConsumerState<PaymentApp> createState() => _PaymentAppState();
}

class _PaymentAppState extends ConsumerState<PaymentApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeNetworkMonitoring();
  }

  void _initializeNetworkMonitoring() {
    final networkInfo = di.sl<NetworkInfo>();
    networkInfo.onConnectivityChanged.listen((isConnected) {
      if (isConnected) {
        _triggerSyncIfNeeded();
      }
    });
  }

  void _triggerSyncIfNeeded() {
    debugPrint('Network connectivity restored, checking for pending transactions...');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConstants.primaryColor,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          elevation: 4,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// === ARCHIVO: lib/core/error/failures.dart ===
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});

  factory ServerFailure.fromStatusCode(int statusCode) {
    String message;
    switch (statusCode) {
      case 400:
        message = 'Bad request: The server could not understand the request';
        break;
      case 401:
        message = 'Unauthorized: Authentication is required';
        break;
      case 403:
        message = 'Forbidden: You do not have permission to access this resource';
        break;
      case 404:
        message = 'Not found: The requested resource does not exist';
        break;
      case 500:
        message = 'Internal server error: Something went wrong on the server';
        break;
      case 503:
        message = 'Service unavailable: The server is temporarily unable to handle the request';
        break;
      default:
        message = 'Server error occurred with status code: $statusCode';
    }
    return ServerFailure(message: message, code: statusCode);
  }
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code});

  factory CacheFailure.notFound() {
    return const CacheFailure(
      message: 'Cache miss: The requested data was not found in local storage',
      code: 404,
    );
  }

  factory CacheFailure.writeError() {
    return const CacheFailure(
      message: 'Cache write error: Failed to save data to local storage',
      code: 500,
    );
  }

  factory CacheFailure.readError() {
    return const CacheFailure(
      message: 'Cache read error: Failed to read data from local storage',
      code: 500,
    );
  }
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.code});

  factory NetworkFailure.noConnection() {
    return const NetworkFailure(
      message: 'No internet connection: Please check your network settings',
      code: -1,
    );
  }

  factory NetworkFailure.timeout() {
    return const NetworkFailure(
      message: 'Connection timeout: The server took too long to respond',
      code: -2,
    );
  }

  factory NetworkFailure.unknown([String? details]) {
    return NetworkFailure(
      message: details ?? 'Unknown network error occurred',
      code: -3,
    );
  }
}

class SyncFailure extends Failure {
  const SyncFailure({required super.message, super.code});

  factory SyncFailure.offlineLimitReached(int currentCount) {
    return SyncFailure(
      message: 'Offline limit reached: Cannot store more than ${AppConstants.maxOfflineTransactions} transactions. Current count: $currentCount. Please sync to continue.',
      code: 507,
    );
  }

  factory SyncFailure.conflict(String transactionId) {
    return SyncFailure(
      message: 'Sync conflict: Transaction $transactionId already exists on server',
      code: 409,
    );
  }

  factory SyncFailure.partialFailure(int syncedCount, int failedCount) {
    return SyncFailure(
      message: 'Partial sync failure: $syncedCount synced, $failedCount failed',
      code: 207,
    );
  }
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code});

  factory ValidationFailure.invalidAmount() {
    return const ValidationFailure(
      message: 'Invalid amount: Amount must be greater than zero',
      code: 400,
    );
  }

  factory ValidationFailure.invalidRecipient() {
    return const ValidationFailure(
      message: 'Invalid recipient: Recipient identifier is required',
      code: 400,
    );
  }

  factory ValidationFailure.missingFields(List<String> fields) {
    return ValidationFailure(
      message: 'Missing required fields: ${fields.join(", ")}',
      code: 400,
    );
  }
}

// === ARCHIVO: lib/core/error/exceptions.dart ===
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({required this.message, this.statusCode});

  @override
  String toString() => 'ServerException: $message (code: $statusCode)';
}

class CacheException implements Exception {
  final String message;
  final String? operation;

  const CacheException({required this.message, this.operation});

  @override
  String toString() => 'CacheException: $message (operation: $operation)';
}

class NetworkException implements Exception {
  final String message;
  final int? code;

  const NetworkException({required this.message, this.code});

  @override
  String toString() => 'NetworkException: $message (code: $code)';
}

class SyncException implements Exception {
  final String message;
  final String? transactionId;
  final bool isRetryable;

  const SyncException({
    required this.message,
    this.transactionId,
    this.isRetryable = false,
  });

  @override
  String toString() => 'SyncException: $message (transactionId: $transactionId, retryable: $isRetryable)';
}

class DatabaseException implements Exception {
  final String message;
  final String? query;
  final dynamic originalError;

  const DatabaseException({
    required this.message,
    this.query,
    this.originalError,
  });

  @override
  String toString() => 'DatabaseException: $message (query: $query, error: $originalError)';
}

class OfflineLimitException implements Exception {
  final int currentCount;
  final int maxAllowed;

  const OfflineLimitException({
    required this.currentCount,
    required this.maxAllowed,
  });

  @override
  String toString() => 'OfflineLimitException: Cannot store more than $maxAllowed transactions offline. Current: $currentCount';
}

class ValidationException implements Exception {
  final String message;
  final Map<String, String>? fieldErrors;

  const ValidationException({required this.message, this.fieldErrors});

  @override
  String toString() => 'ValidationException: $message (fieldErrors: $fieldErrors)';
}

// === ARCHIVO: lib/core/network/network_info.dart ===
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:payment_app/core/error/exceptions.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;
  final StreamController<bool> _connectivityStreamController = StreamController<bool>.broadcast();
  bool _lastKnownState = true;

  NetworkInfoImpl({required this.connectivity}) {
    _initConnectivityListener();
  }

  void _initConnectivityListener() {
    connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final isConnected = _checkConnection(results);
      if (isConnected != _lastKnownState) {
        _lastKnownState = isConnected;
        _connectivityStreamController.add(isConnected);
      }
    });
  }

  bool _checkConnection(List<ConnectivityResult> results) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return false;
    }
    return results.any((result) =>
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.ethernet ||
        result == ConnectivityResult.vpn);
  }

  @override
  Future<bool> get isConnected async {
    try {
      final results = await connectivity.checkConnectivity();
      return _checkConnection(results);
    } catch (e) {
      throw NetworkException(
        message: 'Failed to check connectivity: ${e.toString()}',
        code: -1,
      );
    }
  }

  @override
  Stream<bool> get onConnectivityChanged => _connectivityStreamController.stream;

  Future<void> checkAndNotify() async {
    final isConnectedNow = await isConnected;
    if (isConnectedNow != _lastKnownState) {
      _lastKnownState = isConnectedNow;
      _connectivityStreamController.add(isConnectedNow);
    }
  }

  void dispose() {
    _connectivityStreamController.close();
  }
}

// === ARCHIVO: lib/core/constants/app_constants.dart ===
class AppConstants {
  AppConstants._();

  static const String appName = 'Payment App';
  static const String appVersion = '1.0.0';
  
  static const int maxOfflineTransactions = 100;
  
  static const int syncBatchSize = 50;
  static const int syncRetryAttempts = 3;
  static const int syncRetryDelayMs = 2000;
  
  static const int cacheExpirationHours = 24;
  static const int maxCacheItems = 1000;
  
  static const String baseUrl = 'https://api.payment-app.example.com';
  static const String apiVersion = 'v1';
  static const int connectionTimeoutMs = 30000;
  static const int receiveTimeoutMs = 30000;
  
  static const int primaryColor = 0xFF6366F1;
  static const int secondaryColor = 0xFF8B5CF6;
  static const int errorColor = 0xFFEF4444;
  static const int successColor = 0xFF22C55E;
  static const int warningColor = 0xFFF59E0B;
  
  static const String transactionTableName = 'transactions';
  static const String syncLogTableName = 'sync_log';
  static const String settingsTableName = 'settings';
  
  static const String pendingStatus = 'pending';
  static const String syncedStatus = 'synced';
  static const String failedStatus = 'failed';
  
  static const String secureStorageKeyLastSync = 'last_sync_timestamp';
  static const String secureStorageKeyUserToken = 'user_auth_token';
  static const String secureStorageKeyUserId = 'user_id';
  
  static const double minTransactionAmount = 0.01;
  static const double maxTransactionAmount = 100000.00;
  
  static const String currencyCode = 'USD';
  static const int decimalPlaces = 2;
}


// === ARCHIVO: lib/core/database/app_database.dart ===
package payment_app.core.database;

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:payment_app/core/error/exceptions.dart';
import 'package:payment_app/core/constants/app_constants.dart';

part 'app_database.g.dart';

class Transactions extends Table {
  TextColumn get id => text()();
  TextColumn get recipientId => text()();
  RealColumn get amount => real()();
  TextColumn get currency => text().withDefault(const Constant('USD'))();
  TextColumn get description => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get syncedAt => dateTime().nullable()();
  IntColumn get retryCount => integer().withDefault(const Constant(0))();
  TextColumn get errorMessage => text().nullable()();
  TextColumn get metadata => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class SyncLogs extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get transactionId => text().references(Transactions, #id)();
  TextColumn get action => text()();
  TextColumn get status => text()();
  DateTimeColumn get attemptedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get errorDetails => text().nullable()();
  IntColumn get httpStatusCode => integer().nullable()();
}

class AppSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {key};
}

@DriftDatabase(tables: [Transactions, SyncLogs, AppSettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _initializeDefaultSettings();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.addColumn(transactions, transactions.metadata);
        }
      },
    );
  }

  Future<void> _initializeDefaultSettings() async {
    await into(appSettings).insert(
      AppSettingsCompanion.insert(
        key: 'last_sync_timestamp',
        value: '0',
        updatedAt: DateTime.now(),
      ),
      mode: InsertMode.insertOrIgnore,
    );
    await into(appSettings).insert(
      AppSettingsCompanion.insert(
        key: 'offline_transaction_count',
        value: '0',
        updatedAt: DateTime.now(),
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<int> getPendingTransactionCount() async {
    final query = selectOnly(transactions)
      ..addColumns([transactions.id.count()])
      ..where(transactions.status.equals(AppConstants.pendingStatus));
    final result = await query.getSingle();
    return result.read(transactions.id.count()) ?? 0;
  }

  Future<bool> canStoreOfflineTransaction() async {
    final count = await getPendingTransactionCount();
    return count < AppConstants.maxOfflineTransactions;
  }

  Future<void> insertTransaction(TransactionsCompanion transaction) async {
    try {
      await into(transactions).insert(transaction);
      await _incrementOfflineCount();
    } on SqliteException catch (e) {
      throw DatabaseException(
        message: 'Failed to insert transaction: ${e.message}',
        query: 'INSERT INTO transactions',
        originalError: e,
      );
    }
  }

  Future<List<Transaction>> getPendingTransactions() async {
    try {
      final query = select(transactions)
        ..where((t) => t.status.equals(AppConstants.pendingStatus))
        ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]);
      return await query.get();
    } on SqliteException catch (e) {
      throw DatabaseException(
        message: 'Failed to fetch pending transactions: ${e.message}',
        query: 'SELECT FROM transactions WHERE status = pending',
        originalError: e,
      );
    }
  }

  Future<List<Transaction>> getFailedTransactions() async {
    try {
      final query = select(transactions)
        ..where((t) => t.status.equals(AppConstants.failedStatus))
        ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]);
      return await query.get();
    } on SqliteException catch (e) {
      throw DatabaseException(
        message: 'Failed to fetch failed transactions: ${e.message}',
        query: 'SELECT FROM transactions WHERE status = failed',
        originalError: e,
      );
    }
  }

  Future<Transaction?> getTransactionById(String id) async {
    try {
      final query = select(transactions)..where((t) => t.id.equals(id));
      return await query.getSingleOrNull();
    } on SqliteException catch (e) {
      throw DatabaseException(
        message: 'Failed to fetch transaction: ${e.message}',
        query: 'SELECT FROM transactions WHERE id = ?',
        originalError: e,
      );
    }
  }

  Future<List<Transaction>> getAllTransactions({int? limit, int? offset}) async {
    try {
      var query = select(transactions)
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
      if (limit != null) {
        query = query..limit(limit, offset: offset);
      }
      return await query.get();
    } on SqliteException catch (e) {
      throw DatabaseException(
        message: 'Failed to fetch all transactions: ${e.message}',
        query: 'SELECT FROM transactions ORDER BY createdAt DESC',
        originalError: e,
      );
    }
  }

  Future<void> updateTransactionStatus({
    required String id,
    required String status,
    String? errorMessage,
    DateTime? syncedAt,
  }) async {
    try {
      final query = update(transactions)..where((t) => t.id.equals(id));
      await query.write(
        TransactionsCompanion(
          status: Value(status),
          updatedAt: Value(DateTime.now()),
          errorMessage: Value(errorMessage),
          syncedAt: Value(syncedAt),
        ),
      );
      if (status == AppConstants.syncedStatus || status == AppConstants.failedStatus) {
        await _decrementOfflineCount();
      }
    } on SqliteException catch (e) {
      throw DatabaseException(
        message: 'Failed to update transaction status: ${e.message}',
        query: 'UPDATE transactions SET status = ? WHERE id = ?',
        originalError: e,
      );
    }
  }

  Future<void> deleteTransaction(String id) async {
    try {
      final query = delete(transactions)..where((t) => t.id.equals(id));
      await query.go();
    } on SqliteException catch (e) {
      throw DatabaseException(
        message: 'Failed to delete transaction: ${e.message}',
        query: 'DELETE FROM transactions WHERE id = ?',
        originalError: e,
      );
    }
  }

  Future<void> insertSyncLog(SyncLogsCompanion log) async {
    try {
      await into(syncLogs).insert(log);
    } on SqliteException catch (e) {
      throw DatabaseException(
        message: 'Failed to insert sync log: ${e.message}',
        query: 'INSERT INTO sync_logs',
        originalError: e,
      );
    }
  }

  Future<List<SyncLog>> getRecentSyncLogs({int limit = 50}) async {
    try {
      final query = select(syncLogs)
        ..orderBy([(l) => OrderingTerm.desc(l.attemptedAt)])
        ..limit(limit);
      return await query.get();
    } on SqliteException catch (e) {
      throw DatabaseException(
        message: 'Failed to fetch sync logs: ${e.message}',
        query: 'SELECT FROM sync_logs ORDER BY attemptedAt DESC',
        originalError: e,
      );
    }
  }

  Future<String?> getSetting(String key) async {
    try {
      final query = select(appSettings)..where((s) => s.key.equals(key));
      final result = await query.getSingleOrNull();
      return result?.value;
    } on SqliteException catch (e) {
      throw DatabaseException(
        message: 'Failed to get setting: ${e.message}',
        query: 'SELECT FROM app_settings WHERE key = ?',
        originalError: e,
      );
    }
  }

  Future<void> setSetting(String key, String value) async {
    try {
      await into(appSettings).insertOnConflictUpdate(
        AppSettingsCompanion.insert(
          key: key,
          value: value,
          updatedAt: DateTime.now(),
        ),
      );
    } on SqliteException catch (e) {
      throw DatabaseException(
        message: 'Failed to set setting: ${e.message}',
        query: 'INSERT OR REPLACE INTO app_settings',
        originalError: e,
      );
    }
  }

  Future<void> _incrementOfflineCount() async {
    final currentStr = await getSetting('offline_transaction_count');
    final current = int.tryParse(currentStr ?? '0') ?? 0;
    await setSetting('offline_transaction_count', (current + 1).toString());
  }

  Future<void> _decrementOfflineCount() async {
    final currentStr = await getSetting('offline_transaction_count');
    final current = int.tryParse(currentStr ?? '0') ?? 0;
    if (current > 0) {
      await setSetting('offline_transaction_count', (current - 1).toString());
    }
  }

  Future<void> updateLastSyncTimestamp() async {
    await setSetting(
      'last_sync_timestamp',
      DateTime.now().millisecondsSinceEpoch.toString(),
    );
  }

  Future<void> clearAllData() async {
    try {
      await delete(syncLogs).go();
      await delete(transactions).go();
      await setSetting('offline_transaction_count', '0');
    } on SqliteException catch (e) {
      throw DatabaseException(
        message: 'Failed to clear all data: ${e.message}',
        query: 'DELETE FROM transactions, sync_logs',
        originalError: e,
      );
    }
  }

  Stream<List<Transaction>> watchPendingTransactions() {
    return (select(transactions)
          ..where((t) => t.status.equals(AppConstants.pendingStatus))
          ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
        .watch();
  }

  Stream<List<Transaction>> watchAllTransactions() {
    return (select(transactions)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'payment_app.db'));
    await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    return NativeDatabase.createInBackground(file);
  });
}


// === ARCHIVO: lib/domain/entities/transaction.dart ===
package payment_app.domain.entities;

import 'package:equatable/equatable.dart';

enum TransactionStatus {
  pending,
  synced,
  failed,
}

class Transaction extends Equatable {
  final String id;
  final double amount;
  final String recipient;
  final String recipientAccount;
  final String description;
  final TransactionStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  final int retryCount;
  final String? failureReason;

  const Transaction({
    required this.id,
    required this.amount,
    required this.recipient,
    required this.recipientAccount,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
    this.retryCount = 0,
    this.failureReason,
  });

  bool get isPending => status == TransactionStatus.pending;
  bool get isSynced => status == TransactionStatus.synced;
  bool get isFailed => status == TransactionStatus.failed;
  bool get canRetry => isFailed && retryCount < 3;

  Transaction copyWith({
    String? id,
    double? amount,
    String? recipient,
    String? recipientAccount,
    String? description,
    TransactionStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? syncedAt,
    int? retryCount,
    String? failureReason,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      recipient: recipient ?? this.recipient,
      recipientAccount: recipientAccount ?? this.recipientAccount,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      retryCount: retryCount ?? this.retryCount,
      failureReason: failureReason ?? this.failureReason,
    );
  }

  factory Transaction.create({
    required String id,
    required double amount,
    required String recipient,
    required String recipientAccount,
    String? description,
  }) {
    final now = DateTime.now();
    return Transaction(
      id: id,
      amount: amount,
      recipient: recipient,
      recipientAccount: recipientAccount,
      description: description ?? '',
      status: TransactionStatus.pending,
      createdAt: now,
      updatedAt: now,
      retryCount: 0,
    );
  }

  Transaction markAsSynced() {
    return copyWith(
      status: TransactionStatus.synced,
      syncedAt: DateTime.now(),
      updatedAt: DateTime.now(),
      failureReason: null,
    );
  }

  Transaction markAsFailed(String reason) {
    return copyWith(
      status: TransactionStatus.failed,
      updatedAt: DateTime.now(),
      failureReason: reason,
      retryCount: retryCount + 1,
    );
  }

  @override
  List<Object?> get props => [
        id,
        amount,
        recipient,
        recipientAccount,
        description,
        status,
        createdAt,
        updatedAt,
        syncedAt,
        retryCount,
        failureReason,
      ];
}

// === ARCHIVO: lib/domain/repositories/transaction_repository.dart ===
package payment_app.domain.repositories;

import 'package:dartz/dartz.dart';
import 'package:payment_app/core/error/failures.dart';
import 'package:payment_app/domain/entities/transaction.dart';

abstract class TransactionRepository {
  Future<Either<Failure, Transaction>> saveTransaction(Transaction transaction);

  Future<Either<Failure, Transaction>> getTransactionById(String id);

  Future<Either<Failure, List<Transaction>>> getAllTransactions();

  Future<Either<Failure, List<Transaction>>> getPendingTransactions();

  Future<Either<Failure, List<Transaction>>> getFailedTransactions();

  Future<Either<Failure, Transaction>> updateTransaction(Transaction transaction);

  Future<Either<Failure, void>> deleteTransaction(String id);

  Future<Either<Failure, int>> getPendingTransactionCount();

  Future<Either<Failure, List<Transaction>>> syncPendingTransactions();

  Future<Either<Failure, Transaction>> retryFailedTransaction(String id);

  Future<Either<Failure, void>> clearAllTransactions();

  Future<Either<Failure, void>> clearSyncedTransactions();
}

// === ARCHIVO: lib/domain/usecases/save_transaction.dart ===
package payment_app.domain.usecases;

import 'package:dartz/dartz.dart';
import 'package:payment_app/core/error/exceptions.dart';
import 'package:payment_app/core/error/failures.dart';
import 'package:payment_app/domain/entities/transaction.dart';
import 'package:payment_app/domain/repositories/transaction_repository.dart';

class SaveTransaction {
  final TransactionRepository repository;

  SaveTransaction(this.repository);

  Future<Either<Failure, Transaction>> call({
    required String id,
    required double amount,
    required String recipient,
    required String recipientAccount,
    String? description,
  }) async {
    if (amount <= 0) {
      return Left(ValidationFailure.invalidAmount());
    }

    if (recipient.isEmpty) {
      return Left(ValidationFailure.invalidRecipient());
    }

    if (recipientAccount.isEmpty) {
      return Left(ValidationFailure.missingFields(['recipientAccount']));
    }

    final pendingCountResult = await repository.getPendingTransactionCount();
    
    return pendingCountResult.fold(
      (failure) => Left(failure),
      (count) async {
        if (count >= 100) {
          return Left(SyncFailure.offlineLimitReached(count));
        }

        final transaction = Transaction.create(
          id: id,
          amount: amount,
          recipient: recipient,
          recipientAccount: recipientAccount,
          description: description,
        );

        return repository.saveTransaction(transaction);
      },
    );
  }
}


// === ARCHIVO: lib/domain/usecases/get_pending_transactions.dart ===
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class GetPendingTransactions {
  final TransactionRepository repository;

  GetPendingTransactions(this.repository);

  Future<Either<Failure, List<Transaction>>> call({
    int? limit,
    String? orderBy,
  }) async {
    try {
      final result = await repository.getPendingTransactions(
        limit: limit,
        orderBy: orderBy ?? 'createdAt ASC',
      );
      return result.fold(
        (failure) => Left(failure),
        (transactions) {
          if (transactions.isEmpty) {
            return const Right<Failure, List<Transaction>>([]);
          }
          final validTransactions = transactions.where((t) => 
            t.status == 'pending' && 
            t.amount > 0 &&
            t.recipientId.isNotEmpty
          ).toList();
          return Right<Failure, List<Transaction>>(validTransactions);
        },
      );
    } on CacheException catch (e) {
      return Left(CacheFailure.readError());
    } on DatabaseException catch (e) {
      return Left(CacheFailure(
        message: 'Database error while fetching pending transactions: ${e.message}',
      ));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error: $e'));
    }
  }

  Future<Either<Failure, int>> countPending() async {
    try {
      final result = await repository.getPendingTransactions();
      return result.fold(
        (failure) => Left(failure),
        (transactions) => Right<Failure, int>(
          transactions.where((t) => t.status == 'pending').length,
        ),
      );
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to count pending transactions: $e'));
    }
  }

  Future<Either<Failure, List<Transaction>>> getPendingByRecipient(
    String recipientId,
  ) async {
    try {
      final result = await repository.getPendingTransactions();
      return result.fold(
        (failure) => Left(failure),
        (transactions) {
          final filtered = transactions.where((t) =>
            t.status == 'pending' && t.recipientId == recipientId
          ).toList();
          return Right<Failure, List<Transaction>>(filtered);
        },
      );
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to filter by recipient: $e'));
    }
  }

  Future<Either<Failure, List<Transaction>>> getPendingByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final result = await repository.getPendingTransactions();
      return result.fold(
        (failure) => Left(failure),
        (transactions) {
          final filtered = transactions.where((t) =>
            t.status == 'pending' &&
            t.createdAt.isAfter(startDate) &&
            t.createdAt.isBefore(endDate)
          ).toList();
          filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          return Right<Failure, List<Transaction>>(filtered);
        },
      );
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to filter by date range: $e'));
    }
  }

  Future<Either<Failure, double>> calculatePendingTotal() async {
    try {
      final result = await repository.getPendingTransactions();
      return result.fold(
        (failure) => Left(failure),
        (transactions) {
          final pendingAmount = transactions
            .where((t) => t.status == 'pending')
            .fold<double>(0.0, (sum, t) => sum + t.amount);
          return Right<Failure, double>(pendingAmount);
        },
      );
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to calculate pending total: $e'));
    }
  }
}

// === ARCHIVO: lib/domain/usecases/sync_transactions.dart ===
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../../core/constants/app_constants.dart';
import '../../core/network/network_info.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class SyncTransactions {
  final TransactionRepository repository;
  final NetworkInfo networkInfo;

  SyncTransactions({
    required this.repository,
    required this.networkInfo,
  });

  Future<Either<Failure, SyncResult>> call({
    List<String>? transactionIds,
    bool forceSync = false,
  }) async {
    try {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return Left(NetworkFailure.noConnection());
      }

      final pendingResult = await repository.getPendingTransactions(
        limit: AppConstants.syncBatchSize,
        orderBy: 'createdAt ASC',
      );

      final pendingTransactions = pendingResult.fold(
        (failure) => <Transaction>[],
        (transactions) => transactions.where((t) => t.status == 'pending').toList(),
      );

      if (pendingTransactions.isEmpty) {
        return Right(SyncResult(
          syncedCount: 0,
          failedCount: 0,
          totalCount: 0,
        ));
      }

      final targetIds = transactionIds ?? pendingTransactions.map((t) => t.id).toList();
      final toSync = pendingTransactions
          .where((t) => targetIds.contains(t.id))
          .toList();

      int syncedCount = 0;
      int failedCount = 0;
      final failedIds = <String>[];

      for (final transaction in toSync) {
        try {
          final syncResult = await repository.syncTransaction(transaction);
          
          await syncResult.fold(
            (failure) async {
              failedCount++;
              failedIds.add(transaction.id);
              await repository.updateTransactionStatus(
                transaction.id,
                'failed',
                errorMessage: failure.message,
              );
            },
            (syncedTransaction) async {
              syncedCount++;
              await repository.updateTransactionStatus(
                transaction.id,
                'synced',
              );
            },
          );
        } on SyncException catch (e) {
          failedCount++;
          failedIds.add(transaction.id);
          await repository.updateTransactionStatus(
            transaction.id,
            'failed',
            errorMessage: e.message,
          );
        } catch (e) {
          failedCount++;
          failedIds.add(transaction.id);
        }
      }

      if (failedCount > 0 && syncedCount == 0) {
        return Left(SyncFailure.partialFailure(syncedCount, failedCount));
      }

      return Right(SyncResult(
        syncedCount: syncedCount,
        failedCount: failedCount,
        totalCount: toSync.length,
        failedTransactionIds: failedIds,
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure.unknown(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure.fromStatusCode(e.statusCode ?? 500));
    } catch (e) {
      return Left(SyncFailure(
        message: 'Sync process failed: $e',
      ));
    }
  }

  Future<Either<Failure, SyncResult>> syncAllPending() async {
    return call(forceSync: true);
  }

  Future<Either<Failure, SyncResult>> syncByIds(List<String> ids) async {
    if (ids.isEmpty) {
      return const Right(SyncResult(
        syncedCount: 0,
        failedCount: 0,
        totalCount: 0,
      ));
    }
    return call(transactionIds: ids);
  }

  Future<Either<Failure, bool>> canSyncMore() async {
    try {
      final pendingResult = await repository.getPendingTransactions();
      return pendingResult.fold(
        (failure) => Left(failure),
        (transactions) {
          final pendingCount = transactions.where((t) => t.status == 'pending').length;
          final canSync = pendingCount < AppConstants.maxOfflineTransactions;
          return Right<Failure, bool>(canSync);
        },
      );
    } catch (e) {
      return Left(CacheFailure(message: 'Cannot check sync capacity: $e'));
    }
  }

  Future<Either<Failure, SyncStatistics>> getSyncStatistics() async {
    try {
      final allResult = await repository.getAllTransactions();
      return allResult.fold(
        (failure) => Left(failure),
        (transactions) {
          final pending = transactions.where((t) => t.status == 'pending').length;
          final synced = transactions.where((t) => t.status == 'synced').length;
          final failed = transactions.where((t) => t.status == 'failed').length;
          final pendingTotal = transactions
              .where((t) => t.status == 'pending')
              .fold<double>(0.0, (sum, t) => sum + t.amount);
          
          return Right(SyncStatistics(
            pendingCount: pending,
            syncedCount: synced,
            failedCount: failed,
            pendingTotalAmount: pendingTotal,
          ));
        },
      );
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get sync statistics: $e'));
    }
  }
}

class SyncResult {
  final int syncedCount;
  final int failedCount;
  final int totalCount;
  final List<String> failedTransactionIds;
  final DateTime syncedAt;

  SyncResult({
    required this.syncedCount,
    required this.failedCount,
    required this.totalCount,
    List<String>? failedTransactionIds,
    DateTime? syncedAt,
  })  : failedTransactionIds = failedTransactionIds ?? [],
        syncedAt = syncedAt ?? DateTime.now();

  bool get hasFailures => failedCount > 0;
  bool get isFullySuccessful => failedCount == 0 && syncedCount > 0;
  double get successRate => totalCount > 0 ? syncedCount / totalCount : 0.0;
}

class SyncStatistics {
  final int pendingCount;
  final int syncedCount;
  final int failedCount;
  final double pendingTotalAmount;

  SyncStatistics({
    required this.pendingCount,
    required this.syncedCount,
    required this.failedCount,
    required this.pendingTotalAmount,
  });

  int get totalCount => pendingCount + syncedCount + failedCount;
  double get syncProgress => totalCount > 0 ? syncedCount / totalCount : 0.0;
}

// === ARCHIVO: lib/domain/usecases/get_all_transactions.dart ===
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

enum TransactionFilter {
  all,
  pending,
  synced,
  failed,
}

enum TransactionSortField {
  createdAt,
  amount,
  recipientId,
  status,
}

enum SortOrder {
  ascending,
  descending,
}

class GetAllTransactions {
  final TransactionRepository repository;

  GetAllTransactions(this.repository);

  Future<Either<Failure, List<Transaction>>> call({
    TransactionFilter filter = TransactionFilter.all,
    TransactionSortField sortField = TransactionSortField.createdAt,
    SortOrder sortOrder = SortOrder.descending,
    int? limit,
    int? offset,
    double? minAmount,
    double? maxAmount,
    DateTime? startDate,
    DateTime? endDate,
    String? recipientId,
  }) async {
    try {
      final result = await repository.getAllTransactions(
        limit: limit,
        offset: offset,
      );

      return result.fold(
        (failure) => Left(failure),
        (transactions) {
          var filtered = _applyFilters(
            transactions,
            filter: filter,
            minAmount: minAmount,
            maxAmount: maxAmount,
            startDate: startDate,
            endDate: endDate,
            recipientId: recipientId,
          );

          filtered = _applySorting(filtered, sortField, sortOrder);

          return Right<Failure, List<Transaction>>(filtered);
        },
      );
    } on CacheException catch (e) {
      return Left(CacheFailure.readError());
    } on DatabaseException catch (e) {
      return Left(CacheFailure(
        message: 'Database error while fetching transactions: ${e.message}',
      ));
    } catch (e) {
      return Left(CacheFailure(message: 'Unexpected error fetching transactions: $e'));
    }
  }

  List<Transaction> _applyFilters(
    List<Transaction> transactions, {
    required TransactionFilter filter,
    double? minAmount,
    double? maxAmount,
    DateTime? startDate,
    DateTime? endDate,
    String? recipientId,
  }) {
    var result = transactions;

    switch (filter) {
      case TransactionFilter.pending:
        result = result.where((t) => t.status == 'pending').toList();
        break;
      case TransactionFilter.synced:
        result = result.where((t) => t.status == 'synced').toList();
        break;
      case TransactionFilter.failed:
        result = result.where((t) => t.status == 'failed').toList();
        break;
      case TransactionFilter.all:
        break;
    }

    if (minAmount != null) {
      result = result.where((t) => t.amount >= minAmount).toList();
    }

    if (maxAmount != null) {
      result = result.where((t) => t.amount <= maxAmount).toList();
    }

    if (startDate != null) {
      result = result.where((t) => t.createdAt.isAfter(startDate)).toList();
    }

    if (endDate != null) {
      result = result.where((t) => t.createdAt.isBefore(endDate)).toList();
    }

    if (recipientId != null && recipientId.isNotEmpty) {
      result = result.where((t) => t.recipientId == recipientId).toList();
    }

    return result;
  }

  List<Transaction> _applySorting(
    List<Transaction> transactions,
    TransactionSortField sortField,
    SortOrder sortOrder,
  ) {
    final sorted = List<Transaction>.from(transactions);

    sorted.sort((a, b) {
      int comparison;
      switch (sortField) {
        case TransactionSortField.createdAt:
          comparison = a.createdAt.compareTo(b.createdAt);
          break;
        case TransactionSortField.amount:
          comparison = a.amount.compareTo(b.amount);
          break;
        case TransactionSortField.recipientId:
          comparison = a.recipientId.compareTo(b.recipientId);
          break;
        case TransactionSortField.status:
          comparison = a.status.compareTo(b.status);
          break;
      }
      return sortOrder == SortOrder.ascending ? comparison : -comparison;
    });

    return sorted;
  }

  Future<Either<Failure, Transaction>> getById(String id) async {
    try {
      final result = await repository.getTransactionById(id);
      return result.fold(
        (failure) => Left(failure),
        (transaction) {
          if (transaction == null) {
            return Left(CacheFailure.notFound());
          }
          return Right<Failure, Transaction>(transaction);
        },
      );
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get transaction by id: $e'));
    }
  }

  Future<Either<Failure, List<Transaction>>> getByRecipient(
    String recipientId, {
    TransactionFilter filter = TransactionFilter.all,
  }) async {
    return call(
      filter: filter,
      recipientId: recipientId,
    );
  }

  Future<Either<Failure, List<Transaction>>> getByDateRange(
    DateTime startDate,
    DateTime endDate, {
    TransactionFilter filter = TransactionFilter.all,
  }) async {
    return call(
      filter: filter,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<Either<Failure, TransactionSummary>> getSummary() async {
    try {
      final result = await repository.getAllTransactions();
      return result.fold(
        (failure) => Left(failure),
        (transactions) {
          final pending = transactions.where((t) => t.status == 'pending').toList();
          final synced = transactions.where((t) => t.status == 'synced').toList();
          final failed = transactions.where((t) => t.status == 'failed').toList();

          final pendingTotal = pending.fold<double>(0.0, (sum, t) => sum + t.amount);
          final syncedTotal = synced.fold<double>(0.0, (sum, t) => sum + t.amount);
          final failedTotal = failed.fold<double>(0.0, (sum, t) => sum + t.amount);

          final summary = TransactionSummary(
            totalCount: transactions.length,
            pendingCount: pending.length,
            syncedCount: synced.length,
            failedCount: failed.length,
            pendingTotal: pendingTotal,
            syncedTotal: syncedTotal,
            failedTotal: failedTotal,
            totalAmount: pendingTotal + syncedTotal + failedTotal,
          );

          return Right<Failure, TransactionSummary>(summary);
        },
      );
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get transaction summary: $e'));
    }
  }
}

class TransactionSummary {
  final int totalCount;
  final int pendingCount;
  final int syncedCount;
  final int failedCount;
  final double pendingTotal;
  final double syncedTotal;
  final double failedTotal;
  final double totalAmount;

  TransactionSummary({
    required this.totalCount,
    required this.pendingCount,
    required this.syncedCount,
    required this.failedCount,
    required this.pendingTotal,
    required this.syncedTotal,
    required this.failedTotal,
    required this.totalAmount,
  });

  double get averageAmount => totalCount > 0 ? totalAmount / totalCount : 0.0;
  double get successRate => totalCount > 0 ? syncedCount / totalCount : 0.0;
  double get failureRate => totalCount > 0 ? failedCount / totalCount : 0.0;
}


// === ARCHIVO: lib/data/models/transaction_model.dart ===
import 'package:equatable/equatable.dart';
import '../../domain/entities/transaction.dart';

class TransactionModel extends Equatable {
  final String id;
  final double amount;
  final String recipientId;
  final String recipientName;
  final String? description;
  final DateTime createdAt;
  final DateTime? syncedAt;
  final String status;
  final String? failureReason;
  final int retryCount;

  const TransactionModel({
    required this.id,
    required this.amount,
    required this.recipientId,
    required this.recipientName,
    this.description,
    required this.createdAt,
    this.syncedAt,
    required this.status,
    this.failureReason,
    this.retryCount = 0,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      recipientId: json['recipient_id'] as String,
      recipientName: json['recipient_name'] as String,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      syncedAt: json['synced_at'] != null
          ? DateTime.parse(json['synced_at'] as String)
          : null,
      status: json['status'] as String,
      failureReason: json['failure_reason'] as String?,
      retryCount: json['retry_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'recipient_id': recipientId,
      'recipient_name': recipientName,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'synced_at': syncedAt?.toIso8601String(),
      'status': status,
      'failure_reason': failureReason,
      'retry_count': retryCount,
    };
  }

  factory TransactionModel.fromEntity(Transaction entity) {
    return TransactionModel(
      id: entity.id,
      amount: entity.amount,
      recipientId: entity.recipientId,
      recipientName: entity.recipientName,
      description: entity.description,
      createdAt: entity.createdAt,
      syncedAt: entity.syncedAt,
      status: entity.status,
      failureReason: entity.failureReason,
      retryCount: entity.retryCount,
    );
  }

  Transaction toEntity() {
    return Transaction(
      id: id,
      amount: amount,
      recipientId: recipientId,
      recipientName: recipientName,
      description: description,
      createdAt: createdAt,
      syncedAt: syncedAt,
      status: status,
      failureReason: failureReason,
      retryCount: retryCount,
    );
  }

  TransactionModel copyWith({
    String? id,
    double? amount,
    String? recipientId,
    String? recipientName,
    String? description,
    DateTime? createdAt,
    DateTime? syncedAt,
    String? status,
    String? failureReason,
    int? retryCount,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      recipientId: recipientId ?? this.recipientId,
      recipientName: recipientName ?? this.recipientName,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
      status: status ?? this.status,
      failureReason: failureReason ?? this.failureReason,
      retryCount: retryCount ?? this.retryCount,
    );
  }

  @override
  List<Object?> get props => [
        id,
        amount,
        recipientId,
        recipientName,
        description,
        createdAt,
        syncedAt,
        status,
        failureReason,
        retryCount,
      ];
}

// === ARCHIVO: lib/data/datasources/local/transaction_local_datasource.dart ===
import 'dart:async';
import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/constants/app_constants.dart';
import '../../models/transaction_model.dart';

abstract class TransactionLocalDataSource {
  Future<List<TransactionModel>> getPendingTransactions();
  Future<List<TransactionModel>> getAllTransactions();
  Future<TransactionModel?> getTransactionById(String id);
  Future<void> saveTransaction(TransactionModel transaction);
  Future<void> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
  Future<int> getPendingTransactionsCount();
  Future<void> markAsSynced(String id, DateTime syncedAt);
  Future<void> markAsFailed(String id, String reason);
  Future<void> incrementRetryCount(String id);
  Future<void> clearAllTransactions();
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final AppDatabase database;

  TransactionLocalDataSourceImpl({required this.database});

  @override
  Future<List<TransactionModel>> getPendingTransactions() async {
    try {
      final query = database.select(database.transactions)
        ..where((t) => t.status.equals(AppConstants.pendingStatus))
        ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]);
      final rows = await query.get();
      return rows.map(_mapToModel).toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get pending transactions: $e',
        operation: 'getPendingTransactions',
      );
    }
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    try {
      final query = database.select(database.transactions)
        ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
      final rows = await query.get();
      return rows.map(_mapToModel).toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get all transactions: $e',
        operation: 'getAllTransactions',
      );
    }
  }

  @override
  Future<TransactionModel?> getTransactionById(String id) async {
    try {
      final query = database.select(database.transactions)
        ..where((t) => t.id.equals(id));
      final row = await query.getSingleOrNull();
      return row != null ? _mapToModel(row) : null;
    } catch (e) {
      throw CacheException(
        message: 'Failed to get transaction by id: $e',
        operation: 'getTransactionById',
      );
    }
  }

  @override
  Future<void> saveTransaction(TransactionModel transaction) async {
    try {
      final pendingCount = await getPendingTransactionsCount();
      if (pendingCount >= AppConstants.maxOfflineTransactions) {
        throw OfflineLimitException(
          currentCount: pendingCount,
          maxAllowed: AppConstants.maxOfflineTransactions,
        );
      }
      final companion = TransactionsCompanion.insert(
        id: transaction.id,
        amount: transaction.amount,
        recipientId: transaction.recipientId,
        recipientName: transaction.recipientName,
        description: Value(transaction.description),
        createdAt: transaction.createdAt,
        syncedAt: Value(transaction.syncedAt),
        status: transaction.status,
        failureReason: Value(transaction.failureReason),
        retryCount: transaction.retryCount,
      );
      await database.into(database.transactions).insert(companion);
    } on OfflineLimitException {
      rethrow;
    } catch (e) {
      throw CacheException(
        message: 'Failed to save transaction: $e',
        operation: 'saveTransaction',
      );
    }
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      final companion = TransactionsCompanion(
        id: Value(transaction.id),
        amount: Value(transaction.amount),
        recipientId: Value(transaction.recipientId),
        recipientName: Value(transaction.recipientName),
        description: Value(transaction.description),
        createdAt: Value(transaction.createdAt),
        syncedAt: Value(transaction.syncedAt),
        status: Value(transaction.status),
        failureReason: Value(transaction.failureReason),
        retryCount: Value(transaction.retryCount),
      );
      await (database.update(database.transactions)
            ..where((t) => t.id.equals(transaction.id)))
          .write(companion);
    } catch (e) {
      throw CacheException(
        message: 'Failed to update transaction: $e',
        operation: 'updateTransaction',
      );
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    try {
      await (database.delete(database.transactions)
            ..where((t) => t.id.equals(id)))
          .go();
    } catch (e) {
      throw CacheException(
        message: 'Failed to delete transaction: $e',
        operation: 'deleteTransaction',
      );
    }
  }

  @override
  Future<int> getPendingTransactionsCount() async {
    try {
      final query = database.select(database.transactions)
        ..where((t) => t.status.equals(AppConstants.pendingStatus));
      final rows = await query.get();
      return rows.length;
    } catch (e) {
      throw CacheException(
        message: 'Failed to count pending transactions: $e',
        operation: 'getPendingTransactionsCount',
      );
    }
  }

  @override
  Future<void> markAsSynced(String id, DateTime syncedAt) async {
    try {
      final companion = TransactionsCompanion(
        status: Value(AppConstants.syncedStatus),
        syncedAt: Value(syncedAt),
      );
      await (database.update(database.transactions)
            ..where((t) => t.id.equals(id)))
          .write(companion);
    } catch (e) {
      throw CacheException(
        message: 'Failed to mark transaction as synced: $e',
        operation: 'markAsSynced',
      );
    }
  }

  @override
  Future<void> markAsFailed(String id, String reason) async {
    try {
      final companion = TransactionsCompanion(
        status: Value(AppConstants.failedStatus),
        failureReason: Value(reason),
      );
      await (database.update(database.transactions)
            ..where((t) => t.id.equals(id)))
          .write(companion);
    } catch (e) {
      throw CacheException(
        message: 'Failed to mark transaction as failed: $e',
        operation: 'markAsFailed',
      );
    }
  }

  @override
  Future<void> incrementRetryCount(String id) async {
    try {
      final transaction = await getTransactionById(id);
      if (transaction != null) {
        final companion = TransactionsCompanion(
          retryCount: Value(transaction.retryCount + 1),
        );
        await (database.update(database.transactions)
              ..where((t) => t.id.equals(id)))
            .write(companion);
      }
    } catch (e) {
      throw CacheException(
        message: 'Failed to increment retry count: $e',
        operation: 'incrementRetryCount',
      );
    }
  }

  @override
  Future<void> clearAllTransactions() async {
    try {
      await database.delete(database.transactions).go();
    } catch (e) {
      throw CacheException(
        message: 'Failed to clear all transactions: $e',
        operation: 'clearAllTransactions',
      );
    }
  }

  TransactionModel _mapToModel(Transaction row) {
    return TransactionModel(
      id: row.id,
      amount: row.amount,
      recipientId: row.recipientId,
      recipientName: row.recipientName,
      description: row.description,
      createdAt: row.createdAt,
      syncedAt: row.syncedAt,
      status: row.status,
      failureReason: row.failureReason,
      retryCount: row.retryCount,
    );
  }
}

// === ARCHIVO: lib/data/datasources/remote/transaction_remote_datasource.dart ===
import 'package:dio/dio.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/error/exceptions.dart';
import '../../models/transaction_model.dart';

abstract class TransactionRemoteDataSource {
  Future<List<TransactionModel>> fetchTransactions();
  Future<TransactionModel> createTransaction(TransactionModel transaction);
  Future<TransactionModel> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
  Future<bool> checkServerHealth();
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final Dio dio;

  TransactionRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<TransactionModel>> fetchTransactions() async {
    try {
      final response = await dio.get(
        '${AppConstants.baseUrl}/${AppConstants.apiVersion}/transactions',
        options: Options(
          sendTimeout: Duration(milliseconds: AppConstants.connectionTimeoutMs),
          receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeoutMs),
        ),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['transactions'] as List<dynamic>;
        return data
            .map((json) => TransactionModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          message: 'Failed to fetch transactions',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Unexpected error fetching transactions: $e');
    }
  }

  @override
  Future<TransactionModel> createTransaction(TransactionModel transaction) async {
    try {
      final response = await dio.post(
        '${AppConstants.baseUrl}/${AppConstants.apiVersion}/transactions',
        data: transaction.toJson(),
        options: Options(
          sendTimeout: Duration(milliseconds: AppConstants.connectionTimeoutMs),
          receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeoutMs),
        ),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return TransactionModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: 'Failed to create transaction',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Unexpected error creating transaction: $e');
    }
  }

  @override
  Future<TransactionModel> updateTransaction(TransactionModel transaction) async {
    try {
      final response = await dio.put(
        '${AppConstants.baseUrl}/${AppConstants.apiVersion}/transactions/${transaction.id}',
        data: transaction.toJson(),
        options: Options(
          sendTimeout: Duration(milliseconds: AppConstants.connectionTimeoutMs),
          receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeoutMs),
        ),
      );
      if (response.statusCode == 200) {
        return TransactionModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw ServerException(
          message: 'Failed to update transaction',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Unexpected error updating transaction: $e');
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    try {
      final response = await dio.delete(
        '${AppConstants.baseUrl}/${AppConstants.apiVersion}/transactions/$id',
        options: Options(
          sendTimeout: Duration(milliseconds: AppConstants.connectionTimeoutMs),
          receiveTimeout: Duration(milliseconds: AppConstants.receiveTimeoutMs),
        ),
      );
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(
          message: 'Failed to delete transaction',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Unexpected error deleting transaction: $e');
    }
  }

  @override
  Future<bool> checkServerHealth() async {
    try {
      final response = await dio.get(
        '${AppConstants.baseUrl}/health',
        options: Options(
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  ServerException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ServerException(
          message: 'Connection timeout',
          statusCode: 408,
        );
      case DioExceptionType.connectionError:
        return ServerException(
          message: 'No internet connection',
          statusCode: null,
        );
      case DioExceptionType.badResponse:
        return ServerException(
          message: e.response?.data?['message'] as String? ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.cancel:
        return ServerException(
          message: 'Request cancelled',
          statusCode: null,
        );
      default:
        return ServerException(
          message: e.message ?? 'Unknown network error',
          statusCode: null,
        );
    }
  }
}


// === ARCHIVO: lib/data/repositories/transaction_repository_impl.dart ===
package data.repositories;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/local/transaction_local_datasource.dart';
import '../datasources/remote/transaction_remote_datasource.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;
  final TransactionRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TransactionRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Transaction>> saveTransaction(Transaction transaction) async {
    try {
      final isConnected = await networkInfo.isConnected;
      
      if (isConnected) {
        final remoteModel = _toRemoteModel(transaction);
        final syncedTransaction = await remoteDataSource.createTransaction(remoteModel);
        final savedToLocal = await localDataSource.cacheTransaction(syncedTransaction);
        return Right(savedToLocal);
      } else {
        final pendingCount = await localDataSource.getPendingTransactionsCount();
        if (pendingCount >= 100) {
          return const Left(SyncFailure.offlineLimitReached(100));
        }
        final localModel = _toLocalModel(transaction);
        final savedTransaction = await localDataSource.cacheTransaction(localModel);
        return Right(savedTransaction);
      }
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure.writeError());
    } on NetworkException catch (e) {
      return Left(NetworkFailure.unknown(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getAllTransactions() async {
    try {
      final isConnected = await networkInfo.isConnected;
      
      if (isConnected) {
        final remoteTransactions = await remoteDataSource.getAllTransactions();
        await localDataSource.cacheTransactions(remoteTransactions);
        return Right(remoteTransactions.map(_toEntity).toList());
      } else {
        final localTransactions = await localDataSource.getCachedTransactions();
        return Right(localTransactions.map(_toEntity).toList());
      }
    } on CacheException catch (e) {
      return Left(CacheFailure.readError());
    } on ServerException catch (e) {
      final localTransactions = await localDataSource.getCachedTransactions();
      if (localTransactions.isNotEmpty) {
        return Right(localTransactions.map(_toEntity).toList());
      }
      return Left(ServerFailure.fromStatusCode(e.statusCode ?? 500));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getPendingTransactions() async {
    try {
      final pendingTransactions = await localDataSource.getPendingTransactions();
      return Right(pendingTransactions.map(_toEntity).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure.readError());
    } catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, SyncResult>> syncTransactions() async {
    try {
      final isConnected = await networkInfo.isConnected;
      
      if (!isConnected) {
        return const Left(NetworkFailure.noConnection());
      }

      final pendingTransactions = await localDataSource.getPendingTransactions();
      
      if (pendingTransactions.isEmpty) {
        return const Right(SyncResult(syncedCount: 0, failedCount: 0));
      }

      int syncedCount = 0;
      int failedCount = 0;

      for (final transaction in pendingTransactions) {
        try {
          final remoteModel = _toRemoteModel(_toEntity(transaction));
          await remoteDataSource.createTransaction(remoteModel);
          await localDataSource.updateTransactionStatus(
            transaction.id,
            'synced',
          );
          syncedCount++;
        } on ServerException catch (e) {
          await localDataSource.updateTransactionStatus(
            transaction.id,
            'failed',
          );
          failedCount++;
        } catch (e) {
          failedCount++;
        }
      }

      if (failedCount > 0 && syncedCount == 0) {
        return Left(SyncFailure.partialFailure(syncedCount, failedCount));
      }

      return Right(SyncResult(syncedCount: syncedCount, failedCount: failedCount));
    } on NetworkException catch (e) {
      return Left(NetworkFailure.unknown(e.message));
    } catch (e) {
      return Left(SyncFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> getTransactionById(String id) async {
    try {
      final isConnected = await networkInfo.isConnected;
      
      if (isConnected) {
        try {
          final remoteTransaction = await remoteDataSource.getTransactionById(id);
          await localDataSource.cacheTransaction(remoteTransaction);
          return Right(_toEntity(remoteTransaction));
        } on ServerException {
          final localTransaction = await localDataSource.getTransactionById(id);
          return Right(_toEntity(localTransaction));
        }
      } else {
        final localTransaction = await localDataSource.getTransactionById(id);
        return Right(_toEntity(localTransaction));
      }
    } on CacheException catch (e) {
      return Left(CacheFailure.notFound());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(String id) async {
    try {
      final isConnected = await networkInfo.isConnected;
      
      if (isConnected) {
        await remoteDataSource.deleteTransaction(id);
      }
      await localDataSource.deleteTransaction(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure.fromStatusCode(e.statusCode ?? 500));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Transaction _toEntity(TransactionModel model) {
    return Transaction(
      id: model.id,
      amount: model.amount,
      recipientId: model.recipientId,
      recipientName: model.recipientName,
      status: model.status,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      description: model.description,
    );
  }

  TransactionModel _toLocalModel(Transaction entity) {
    return TransactionModel(
      id: entity.id,
      amount: entity.amount,
      recipientId: entity.recipientId,
      recipientName: entity.recipientName,
      status: 'pending',
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      description: entity.description,
    );
  }

  TransactionModel _toRemoteModel(Transaction entity) {
    return TransactionModel(
      id: entity.id,
      amount: entity.amount,
      recipientId: entity.recipientId,
      recipientName: entity.recipientName,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      description: entity.description,
    );
  }
}

class SyncResult extends Equatable {
  final int syncedCount;
  final int failedCount;

  const SyncResult({
    required this.syncedCount,
    required this.failedCount,
  });

  @override
  List<Object?> get props => [syncedCount, failedCount];
}

// === ARCHIVO: test/domain/usecases/save_transaction_test.dart ===
package test.domain.usecases;

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:payment_app/core/error/failures.dart';
import 'package:payment_app/core/network/network_info.dart';
import 'package:payment_app/domain/entities/transaction.dart';
import 'package:payment_app/domain/repositories/transaction_repository.dart';
import 'package:payment_app/domain/usecases/save_transaction.dart';

import 'save_transaction_test.mocks.dart';

@GenerateMocks([TransactionRepository, NetworkInfo])
void main() {
  late SaveTransaction useCase;
  late MockTransactionRepository mockRepository;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRepository = MockTransactionRepository();
    mockNetworkInfo = MockNetworkInfo();
    useCase = SaveTransaction(
      repository: mockRepository,
      networkInfo: mockNetworkInfo,
    );
  });

  final tTransaction = Transaction(
    id: 'test-id-123',
    amount: 100.50,
    recipientId: 'recipient-456',
    recipientName: 'Test Recipient',
    status: 'pending',
    createdAt: DateTime(2024, 1, 15, 10, 30),
    updatedAt: DateTime(2024, 1, 15, 10, 30),
    description: 'Test transaction',
  );

  group('execute', () {
    test('debe guardar la transacción en el servidor cuando hay conexión', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRepository.saveTransaction(tTransaction))
          .thenAnswer((_) async => Right(tTransaction));

      final result = await useCase.execute(tTransaction);

      expect(result, Right(tTransaction));
      verify(mockNetworkInfo.isConnected);
      verify(mockRepository.saveTransaction(tTransaction));
      verifyNoMoreInteractions(mockRepository);
    });

    test('debe guardar la transacción en cache cuando no hay conexión', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockRepository.saveTransaction(tTransaction))
          .thenAnswer((_) async => Right(tTransaction));

      final result = await useCase.execute(tTransaction);

      expect(result, Right(tTransaction));
      verify(mockNetworkInfo.isConnected);
      verify(mockRepository.saveTransaction(tTransaction));
    });

    test('debe retornar ValidationFailure cuando el monto es inválido', () async {
      final invalidTransaction = Transaction(
        id: 'test-id-123',
        amount: -50.0,
        recipientId: 'recipient-456',
        recipientName: 'Test Recipient',
        status: 'pending',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        description: 'Invalid amount',
      );

      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRepository.saveTransaction(invalidTransaction))
          .thenAnswer((_) async => const Left(ValidationFailure.invalidAmount()));

      final result = await useCase.execute(invalidTransaction);

      expect(result, const Left(ValidationFailure.invalidAmount()));
    });

    test('debe retornar SyncFailure.offlineLimitReached cuando hay más de 100 transacciones pendientes', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockRepository.saveTransaction(tTransaction)).thenAnswer(
        (_) async => const Left(SyncFailure.offlineLimitReached(100)),
      );

      final result = await useCase.execute(tTransaction);

      expect(result, const Left(SyncFailure.offlineLimitReached(100)));
    });

    test('debe retornar NetworkFailure cuando no hay conexión y falla el guardado local', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockRepository.saveTransaction(tTransaction))
          .thenAnswer((_) async => Left(CacheFailure.writeError()));

      final result = await useCase.execute(tTransaction);

      expect(result, Left(CacheFailure.writeError()));
    });

    test('debe retornar ServerFailure cuando el servidor falla con conexión', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRepository.saveTransaction(tTransaction))
          .thenAnswer((_) async => Left(ServerFailure('Server error')));

      final result = await useCase.execute(tTransaction);

      expect(result, Left(ServerFailure('Server error')));
    });

    test('debe verificar la conexión antes de intentar guardar', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRepository.saveTransaction(tTransaction))
          .thenAnswer((_) async => Right(tTransaction));

      await useCase.execute(tTransaction);

      verifyInOrder([
        mockNetworkInfo.isConnected,
        mockRepository.saveTransaction(tTransaction),
      ]);
    });

    test('debe propagar cualquier excepción inesperada como Failure', () async {
      when(mockNetworkInfo.isConnected).thenThrow(Exception('Network check failed'));

      final result = await useCase.execute(tTransaction);

      expect(result.isLeft(), true);
    });
  });

  group('validación de parámetros', () {
    test('debe retornar ValidationFailure cuando el recipient está vacío', () async {
      final invalidTransaction = Transaction(
        id: 'test-id-123',
        amount: 100.0,
        recipientId: '',
        recipientName: '',
        status: 'pending',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        description: 'Test',
      );

      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRepository.saveTransaction(invalidTransaction))
          .thenAnswer((_) async => const Left(ValidationFailure.invalidRecipient()));

      final result = await useCase.execute(invalidTransaction);

      expect(result, const Left(ValidationFailure.invalidRecipient()));
    });

    test('debe retornar ValidationFailure cuando faltan campos requeridos', () async {
      final incompleteTransaction = Transaction(
        id: 'test-id',
        amount: 0,
        recipientId: 'rec-1',
        recipientName: 'Name',
        status: 'pending',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        description: null,
      );

      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRepository.saveTransaction(incompleteTransaction)).thenAnswer(
        (_) async => const Left(ValidationFailure.missingFields(['amount'])),
      );

      final result = await useCase.execute(incompleteTransaction);

      expect(result, const Left(ValidationFailure.missingFields(['amount'])));
    });
  });

  group('comportamiento offline', () {
    test('debe intentar sincronización automática cuando se recupera la conexión', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockNetworkInfo.onConnectivityChanged).thenAnswer(
        (_) => Stream.value(true),
      );
      when(mockRepository.saveTransaction(tTransaction))
          .thenAnswer((_) async => Right(tTransaction));

      await useCase.execute(tTransaction);
      await Future.delayed(const Duration(milliseconds: 100));

      verify(mockRepository.saveTransaction(tTransaction));
    });
  });
}

// === ARCHIVO: lib/presentation/bloc/transaction_event.dart ===
part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactionsEvent extends TransactionEvent {
  const LoadTransactionsEvent();
}

class LoadPendingTransactionsEvent extends TransactionEvent {
  const LoadPendingTransactionsEvent();
}

class AddTransactionEvent extends TransactionEvent {
  final String recipientId;
  final double amount;
  final String description;
  final DateTime scheduledDate;

  const AddTransactionEvent({
    required this.recipientId,
    required this.amount,
    required this.description,
    required this.scheduledDate,
  });

  @override
  List<Object?> get props => [recipientId, amount, description, scheduledDate];
}

class SyncTransactionsEvent extends TransactionEvent {
  const SyncTransactionsEvent();
}

class DeleteTransactionEvent extends TransactionEvent {
  final String transactionId;

  const DeleteTransactionEvent({required this.transactionId});

  @override
  List<Object?> get props => [transactionId];
}

class RetrySyncSingleEvent extends TransactionEvent {
  final String transactionId;

  const RetrySyncSingleEvent({required this.transactionId});

  @override
  List<Object?> get props => [transactionId];
}

class RefreshConnectivityEvent extends TransactionEvent {
  final bool isConnected;

  const RefreshConnectivityEvent({required this.isConnected});

  @override
  List<Object?> get props => [isConnected];
}

class ClearErrorEvent extends TransactionEvent {
  const ClearErrorEvent();
}

// === ARCHIVO: lib/presentation/bloc/transaction_state.dart ===
part of 'transaction_bloc.dart';

enum TransactionSyncStatus {
  idle,
  syncing,
  synced,
  failed,
  partialFailure,
}

class TransactionState extends Equatable {
  final List<Transaction> transactions;
  final List<Transaction> pendingTransactions;
  final bool isLoading;
  final bool isSyncing;
  final bool isConnected;
  final String? errorMessage;
  final TransactionSyncStatus syncStatus;
  final int syncedCount;
  final int failedCount;
  final int offlineCount;

  const TransactionState({
    this.transactions = const [],
    this.pendingTransactions = const [],
    this.isLoading = false,
    this.isSyncing = false,
    this.isConnected = true,
    this.errorMessage,
    this.syncStatus = TransactionSyncStatus.idle,
    this.syncedCount = 0,
    this.failedCount = 0,
    this.offlineCount = 0,
  });

  TransactionState copyWith({
    List<Transaction>? transactions,
    List<Transaction>? pendingTransactions,
    bool? isLoading,
    bool? isSyncing,
    bool? isConnected,
    String? errorMessage,
    TransactionSyncStatus? syncStatus,
    int? syncedCount,
    int? failedCount,
    int? offlineCount,
    bool clearError = false,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      pendingTransactions: pendingTransactions ?? this.pendingTransactions,
      isLoading: isLoading ?? this.isLoading,
      isSyncing: isSyncing ?? this.isSyncing,
      isConnected: isConnected ?? this.isConnected,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      syncStatus: syncStatus ?? this.syncStatus,
      syncedCount: syncedCount ?? this.syncedCount,
      failedCount: failedCount ?? this.failedCount,
      offlineCount: offlineCount ?? this.offlineCount,
    );
  }

  bool get hasPendingTransactions => pendingTransactions.isNotEmpty;
  bool get canSync => isConnected && hasPendingTransactions;
  bool get hasError => errorMessage != null;

  double get totalPendingAmount {
    return pendingTransactions.fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalSyncedAmount {
    return transactions
        .where((t) => t.status == AppConstants.syncedStatus)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  @override
  List<Object?> get props => [
        transactions,
        pendingTransactions,
        isLoading,
        isSyncing,
        isConnected,
        errorMessage,
        syncStatus,
        syncedCount,
        failedCount,
        offlineCount,
      ];
}

// === ARCHIVO: lib/presentation/bloc/transaction_bloc.dart ===
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/usecases/save_transaction.dart';
import '../../domain/usecases/get_pending_transactions.dart';
import '../../domain/usecases/sync_transactions.dart';
import '../../domain/usecases/get_all_transactions.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends StateNotifier<TransactionState> {
  final SaveTransaction saveTransaction;
  final GetPendingTransactions getPendingTransactions;
  final SyncTransactions syncTransactions;
  final GetAllTransactions getAllTransactions;

  TransactionBloc({
    required this.saveTransaction,
    required this.getPendingTransactions,
    required this.syncTransactions,
    required this.getAllTransactions,
  }) : super(const TransactionState());

  Future<void> onLoadTransactions() async {
    state = state.copyWith(isLoading: true, clearError: true);

    finalEither = await getAllTransactions();

    finalEither.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (transactions) {
        final pending = transactions
            .where((t) => t.status == AppConstants.pendingStatus)
            .toList();

        state = state.copyWith(
          isLoading: false,
          transactions: transactions,
          pendingTransactions: pending,
          offlineCount: pending.length,
        );
      },
    );
  }

  Future<void> onLoadPendingTransactions() async {
    state = state.copyWith(isLoading: true, clearError: true);

    finalEither = await getPendingTransactions();

    finalEither.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (pendingTransactions) {
        state = state.copyWith(
          isLoading: false,
          pendingTransactions: pendingTransactions,
          offlineCount: pendingTransactions.length,
        );
      },
    );
  }

  Future<void> onAddTransaction(AddTransactionEvent event) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final transaction = Transaction(
      id: '',
      recipientId: event.recipientId,
      amount: event.amount,
      description: event.description,
      scheduledDate: event.scheduledDate,
      status: AppConstants.pendingStatus,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final saveResult = await saveTransaction(transaction);

    await saveResult.fold(
      (failure) async {
        String errorMsg = failure.message;
        if (failure is SyncFailure) {
          final offlineLimitFailure = failure;
          errorMsg =
              'No se pueden guardar más transacciones offline. Límite alcanzado: ${AppConstants.maxOfflineTransactions}';
        }
        state = state.copyWith(
          isLoading: false,
          errorMessage: errorMsg,
        );
      },
      (_) async {
        await onLoadTransactions();
      },
    );
  }

  Future<void> onSyncTransactions() async {
    if (!state.isConnected) {
      state = state.copyWith(
        errorMessage: 'No hay conexión a internet para sincronizar',
      );
      return;
    }

    if (state.pendingTransactions.isEmpty) {
      return;
    }

    state = state.copyWith(
      isSyncing: true,
      syncStatus: TransactionSyncStatus.syncing,
      clearError: true,
    );

    final syncResult = await syncTransactions(state.pendingTransactions);

    syncResult.fold(
      (failure) {
        if (failure is SyncFailure) {
          state = state.copyWith(
            isSyncing: false,
            syncStatus: TransactionSyncStatus.failed,
            errorMessage: failure.message,
          );
        } else {
          state = state.copyWith(
            isSyncing: false,
            syncStatus: TransactionSyncStatus.failed,
            errorMessage: failure.message,
          );
        }
      },
      (syncResponse) {
        state = state.copyWith(
          isSyncing: false,
          syncStatus: syncResponse.failedCount > 0
              ? TransactionSyncStatus.partialFailure
              : TransactionSyncStatus.synced,
          syncedCount: syncResponse.syncedCount,
          failedCount: syncResponse.failedCount,
        );
        onLoadTransactions();
      },
    );
  }

  Future<void> onDeleteTransaction(String transactionId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final deleteResult = await Future.value(
      const Right<Failure, bool>(true),
    );

    await deleteResult.fold(
      (failure) async {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (_) async {
        final updatedTransactions = state.transactions
            .where((t) => t.id != transactionId)
            .toList();
        final updatedPending = state.pendingTransactions
            .where((t) => t.id != transactionId)
            .toList();

        state = state.copyWith(
          isLoading: false,
          transactions: updatedTransactions,
          pendingTransactions: updatedPending,
          offlineCount: updatedPending.length,
        );
      },
    );
  }

  Future<void> onRetrySyncSingle(String transactionId) async {
    final pendingTx = state.pendingTransactions
        .where((t) => t.id == transactionId)
        .toList();

    if (pendingTx.isEmpty) {
      return;
    }

    state = state.copyWith(
      isSyncing: true,
      syncStatus: TransactionSyncStatus.syncing,
      clearError: true,
    );

    final syncResult = await syncTransactions(pendingTx);

    syncResult.fold(
      (failure) {
        state = state.copyWith(
          isSyncing: false,
          syncStatus: TransactionSyncStatus.failed,
          errorMessage: failure.message,
        );
      },
      (syncResponse) {
        state = state.copyWith(
          isSyncing: false,
          syncStatus: syncResponse.failedCount > 0
              ? TransactionSyncStatus.partialFailure
              : TransactionSyncStatus.synced,
          syncedCount: syncResponse.syncedCount,
          failedCount: syncResponse.failedCount,
        );
        onLoadTransactions();
      },
    );
  }

  void onConnectivityChanged(bool isConnected) {
    final wasConnected = state.isConnected;
    state = state.copyWith(isConnected: isConnected);

    if (!wasConnected && isConnected && state.hasPendingTransactions) {
      onSyncTransactions();
    }
  }

  void onClearError() {
    state = state.copyWith(clearError: true);
  }
}


// === ARCHIVO: lib/presentation/screens/home_screen.dart ===
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/domain/entities/transaction.dart';
import 'package:payment_app/presentation/bloc/transaction_bloc.dart';
import 'package:payment_app/presentation/bloc/transaction_event.dart';
import 'package:payment_app/presentation/bloc/transaction_state.dart';
import 'package:payment_app/presentation/widgets/transaction_item.dart';
import 'package:payment_app/presentation/widgets/sync_status_indicator.dart';
import 'package:payment_app/core/constants/app_constants.dart';
import 'add_transaction_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(transactionBlocProvider.notifier).add(LoadTransactionsEvent());
    });
  }

  Future<void> _onRefresh() async {
    ref.read(transactionBlocProvider.notifier).add(SyncTransactionsEvent());
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _navigateToAddTransaction() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => const AddTransactionScreen(),
      ),
    );
    if (result == true && mounted) {
      ref.read(transactionBlocProvider.notifier).add(LoadTransactionsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionState = ref.watch(transactionBlocProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        backgroundColor: Color(AppConstants.primaryColor),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(transactionBlocProvider.notifier).add(SyncTransactionsEvent());
            },
            tooltip: 'Sincronizar transacciones',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(AppConstants.primaryColor).withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mis Transacciones',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Color(AppConstants.primaryColor),
                  ),
                ),
                const SizedBox(height: 8),
                const SyncStatusIndicator(),
              ],
            ),
          ),
          Expanded(
            child: _buildTransactionList(transactionState, theme),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddTransaction,
        backgroundColor: Color(AppConstants.primaryColor),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nueva Transacción'),
      ),
    );
  }

  Widget _buildTransactionList(TransactionState state, ThemeData theme) {
    if (state is TransactionLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is TransactionError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Color(AppConstants.errorColor),
              ),
              const SizedBox(height: 16),
              Text(
                state.message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(transactionBlocProvider.notifier).add(LoadTransactionsEvent());
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (state is TransactionLoaded) {
      if (state.transactions.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 80,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(height: 16),
                Text(
                  'No hay transacciones',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Toca el botón + para crear tu primera transacción',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }

      final pendingCount = state.transactions.where((t) => t.status == AppConstants.pendingStatus).length;
      final syncedCount = state.transactions.where((t) => t.status == AppConstants.syncedStatus).length;
      final failedCount = state.transactions.where((t) => t.status == AppConstants.failedStatus).length;

      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatusChip(
                    'Pendientes',
                    pendingCount,
                    Color(AppConstants.warningColor),
                  ),
                  _buildStatusChip(
                    'Sincronizadas',
                    syncedCount,
                    Color(AppConstants.successColor),
                  ),
                  _buildStatusChip(
                    'Fallidas',
                    failedCount,
                    Color(AppConstants.errorColor),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: state.transactions.length,
                itemBuilder: (context, index) {
                  final transaction = state.transactions[index];
                  return TransactionItem(
                    transaction: transaction,
                    onTap: () => _showTransactionDetails(transaction),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    return const Center(
      child: Text('Cargando transacciones...'),
    );
  }

  Widget _buildStatusChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$label: $count',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showTransactionDetails(Transaction transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Detalles de Transacción',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildDetailRow('ID', transaction.id),
              _buildDetailRow('Monto', '\${transaction.amount.toStringAsFixed(2)}'),
              _buildDetailRow('Destinatario', transaction.recipient),
              _buildDetailRow('Estado', _getStatusLabel(transaction.status)),
              _buildDetailRow('Fecha', _formatDate(transaction.createdAt)),
              if (transaction.description != null)
                _buildDetailRow('Descripción', transaction.description!),
              if (transaction.errorMessage != null)
                _buildDetailRow('Error', transaction.errorMessage!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case AppConstants.pendingStatus:
        return 'Pendiente';
      case AppConstants.syncedStatus:
        return 'Sincronizada';
      case AppConstants.failedStatus:
        return 'Fallida';
      default:
        return status;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

// === ARCHIVO: lib/presentation/screens/add_transaction_screen.dart ===
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/core/constants/app_constants.dart';
import 'package:payment_app/core/error/failures.dart';
import 'package:payment_app/presentation/bloc/transaction_bloc.dart';
import 'package:payment_app/presentation/bloc/transaction_event.dart';
import 'package:payment_app/presentation/bloc/transaction_state.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _recipientController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _amountController.dispose();
    _recipientController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submitTransaction() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final amount = double.tryParse(_amountController.text.replaceAll(',', '.'));
    if (amount == null) {
      setState(() {
        _isSubmitting = false;
        _errorMessage = 'Monto inválido';
      });
      return;
    }

    if (amount < AppConstants.minTransactionAmount || amount > AppConstants.maxTransactionAmount) {
      setState(() {
        _isSubmitting = false;
        _errorMessage = 'El monto debe estar entre \${AppConstants.minTransactionAmount} y \${AppConstants.maxTransactionAmount}';
      });
      return;
    }

    ref.read(transactionBlocProvider.notifier).add(
      SaveTransactionEvent(
        amount: amount,
        recipient: _recipientController.text.trim(),
        description: _descriptionController.text.trim().isEmpty 
            ? null 
            : _descriptionController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    ref.listen<TransactionState>(transactionBlocProvider, (previous, next) {
      if (next is TransactionSaved) {
        if (next.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle, color: Color(AppConstants.successColor)),
                  const SizedBox(width: 12),
                  const Text('Transacción guardada correctamente'),
                ],
              ),
              backgroundColor: Colors.white,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          );
          Navigator.of(context).pop(true);
        } else {
          setState(() {
            _isSubmitting = false;
            _errorMessage = next.failure?.message ?? 'Error al guardar la transacción';
          });
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Transacción'),
        backgroundColor: Color(AppConstants.primaryColor),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(AppConstants.primaryColor),
                      Color(AppConstants.primaryColor).withValues(alpha: 0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.account_balance_wallet,
                      size: 48,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Nueva Transferencia',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ingresa los datos de la transacción',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              _buildAmountField(theme),
              const SizedBox(height: 20),
              _buildRecipientField(theme),
              const SizedBox(height: 20),
              _buildDescriptionField(theme),
              const SizedBox(height: 12),
              _buildLimitInfo(theme),
              if (_errorMessage != null) ...
                [
                  const SizedBox(height: 16),
                  _buildErrorMessage(theme),
                ],
              const SizedBox(height: 32),
              _buildSubmitButton(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAmountField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monto',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _amountController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
          ],
          decoration: InputDecoration(
            prefixText: '\${AppConstants.currencyCode} ',
            prefixStyle: TextStyle(
              color: Color(AppConstants.primaryColor),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            hintText: '0.00',
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(AppConstants.primaryColor), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(AppConstants.errorColor)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa el monto';
            }
            final amount = double.tryParse(value.replaceAll(',', '.'));
            if (amount == null) {
              return 'Monto inválido';
            }
            if (amount < AppConstants.minTransactionAmount) {
              return 'El monto mínimo es \${AppConstants.minTransactionAmount}';
            }
            if (amount > AppConstants.maxTransactionAmount) {
              return 'El monto máximo es \${AppConstants.maxTransactionAmount}';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildRecipientField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Destinatario',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _recipientController,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(
            hintText: 'Nombre del beneficiario',
            prefixIcon: Icon(Icons.person_outline, color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(AppConstants.primaryColor), width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(AppConstants.errorColor)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Ingresa el nombre del destinatario';
            }
            if (value.trim().length < 3) {
              return 'El nombre debe tener al menos 3 caracteres';
            }
            if (value.trim().length > 100) {
              return 'El nombre no puede exceder 100 caracteres';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descripción (opcional)',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descriptionController,
          maxLines: 3,
          maxLength: 250,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            hintText: 'Agrega una descripción para esta transacción',
            prefixIcon: Padding(
              padding: const EdgeInsets.only(bottom: 48),
              child: Icon(Icons.notes, color: Colors.grey[600]),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(AppConstants.primaryColor), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget _buildLimitInfo(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(AppConstants.warningColor).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Color(AppConstants.warningColor).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Color(AppConstants.warningColor),
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Puedes guardar hasta ${AppConstants.maxOfflineTransactions} transacciones sin conexión. '
              'Se sincronizarán cuando tengas conexión a internet.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: Color(AppConstants.warningColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(AppConstants.errorColor).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Color(AppConstants.errorColor).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: Color(AppConstants.errorColor),
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Color(AppConstants.errorColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(ThemeData theme) {
    return SizedBox(
      height: 56,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _submitTransaction,
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(AppConstants.primaryColor),
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.send),
                  const SizedBox(width: 8),
                  Text(
                    'Crear Transacción',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

// === ARCHIVO: lib/presentation/widgets/transaction_item.dart ===
import 'package:flutter/material.dart';
import 'package:payment_app/core/constants/app_constants.dart';
import 'package:payment_app/domain/entities/transaction.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;

  const TransactionItem({
    super.key,
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor();
    final statusIcon = _getStatusIcon();
    final statusLabel = _getStatusLabel();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  statusIcon,
                  color: statusColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.recipient,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          _formatDate(transaction.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        if (transaction.description != null && transaction.description!.isNotEmpty) ...
                          [
                            const SizedBox(width: 8),
                            Icon(
                              Icons.notes,
                              size: 14,
                              color: Colors.grey[400],
                            ),
                          ],
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\${transaction.amount.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Color(AppConstants.primaryColor),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (transaction.status) {
      case AppConstants.pendingStatus:
        return Color(AppConstants.warningColor);
      case AppConstants.syncedStatus:
        return Color(AppConstants.successColor);
      case AppConstants.failedStatus:
        return Color(AppConstants.errorColor);
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon() {
    switch (transaction.status) {
      case AppConstants.pendingStatus:
        return Icons.schedule;
      case AppConstants.syncedStatus:
        return Icons.check_circle;
      case AppConstants.failedStatus:
        return Icons.error;
      default:
        return Icons.help_outline;
    }
  }

  String _getStatusLabel() {
    switch (transaction.status) {
      case AppConstants.pendingStatus:
        return 'Pendiente';
      case AppConstants.syncedStatus:
        return 'Sincronizada';
      case AppConstants.failedStatus:
        return 'Fallida';
      default:
        return transaction.status;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Hace un momento';
        }
        return 'Hace ${difference.inMinutes} min';
      }
      return 'Hace ${difference.inHours} h';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../core/network/network_info.dart';
import '../../core/constants/app_constants.dart';

enum SyncStatus { synced, pending, failed, offline }

class SyncStatusIndicator extends ConsumerStatefulWidget {
  final VoidCallback? onSyncPressed;
  final bool showLabel;
  final double iconSize;

  const SyncStatusIndicator({
    super.key,
    this.onSyncPressed,
    this.showLabel = true,
    this.iconSize = 24.0,
  });

  @override
  ConsumerState<SyncStatusIndicator> createState() => _SyncStatusIndicatorState();
}

class _SyncStatusIndicatorState extends ConsumerState<SyncStatusIndicator> {
  SyncStatus _currentStatus = SyncStatus.offline;
  bool _isSyncing = false;
  int _pendingCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeStatus();
  }

  void _initializeStatus() async {
    final networkInfo = ref.read(networkInfoProvider);
    final isConnected = await networkInfo.isConnected;
    
    if (!isConnected) {
      setState(() => _currentStatus = SyncStatus.offline);
    }
    
    _listenToConnectivityChanges();
  }

  void _listenToConnectivityChanges() {
    final networkInfo = ref.read(networkInfoProvider);
    networkInfo.onConnectivityChanged.listen((isConnected) {
      if (mounted) {
        setState(() {
          if (!isConnected) {
            _currentStatus = SyncStatus.offline;
          } else if (_pendingCount > 0) {
            _currentStatus = SyncStatus.pending;
          } else {
            _currentStatus = SyncStatus.synced;
          }
        });
      }
    });
  }

  void _updatePendingCount(int count) {
    if (mounted) {
      setState(() {
        _pendingCount = count;
        if (_currentStatus != SyncStatus.offline) {
          _currentStatus = count > 0 ? SyncStatus.pending : SyncStatus.synced;
        }
      });
    }
  }

  Future<void> _handleSync() async {
    if (_isSyncing || _currentStatus == SyncStatus.offline) return;
    
    setState(() => _isSyncing = true);
    
    try {
      widget.onSyncPressed?.call();
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (mounted) {
        setState(() {
          _isSyncing = false;
          _pendingCount = 0;
          _currentStatus = SyncStatus.synced;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSyncing = false;
          _currentStatus = SyncStatus.failed;
        });
      }
    }
  }

  Color _getStatusColor() {
    switch (_currentStatus) {
      case SyncStatus.synced:
        return Color(AppConstants.successColor);
      case SyncStatus.pending:
        return Color(AppConstants.warningColor);
      case SyncStatus.failed:
        return Color(AppConstants.errorColor);
      case SyncStatus.offline:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon() {
    switch (_currentStatus) {
      case SyncStatus.synced:
        return Icons.cloud_done;
      case SyncStatus.pending:
        return Icons.cloud_upload;
      case SyncStatus.failed:
        return Icons.cloud_off;
      case SyncStatus.offline:
        return Icons.cloud_outlined;
    }
  }

  String _getStatusLabel() {
    switch (_currentStatus) {
      case SyncStatus.synced:
        return 'Sincronizado';
      case SyncStatus.pending:
        return '$_pendingCount pendiente${_pendingCount != 1 ? 's' : ''}';
      case SyncStatus.failed:
        return 'Error de sincronización';
      case SyncStatus.offline:
        return 'Sin conexión';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleSync,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _getStatusColor().withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _getStatusColor().withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isSyncing)
              SizedBox(
                width: widget.iconSize,
                height: widget.iconSize,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(_getStatusColor()),
                ),
              )
            else
              Icon(
                _getStatusIcon(),
                size: widget.iconSize,
                color: _getStatusColor(),
              ),
            if (widget.showLabel) ...[
              const SizedBox(width: 8),
              Text(
                _getStatusLabel(),
                style: TextStyle(
                  color: _getStatusColor(),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl(Connectivity());
});

final syncStatusProvider = StateNotifierProvider<SyncStatusNotifier, SyncStatusState>((ref) {
  final networkInfo = ref.watch(networkInfoProvider);
  return SyncStatusNotifier(networkInfo);
});

class SyncStatusState {
  final SyncStatus status;
  final int pendingCount;
  final bool isSyncing;
  final DateTime? lastSyncTime;

  const SyncStatusState({
    this.status = SyncStatus.offline,
    this.pendingCount = 0,
    this.isSyncing = false,
    this.lastSyncTime,
  });

  SyncStatusState copyWith({
    SyncStatus? status,
    int? pendingCount,
    bool? isSyncing,
    DateTime? lastSyncTime,
  }) {
    return SyncStatusState(
      status: status ?? this.status,
      pendingCount: pendingCount ?? this.pendingCount,
      isSyncing: isSyncing ?? this.isSyncing,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }
}

class SyncStatusNotifier extends StateNotifier<SyncStatusState> {
  final NetworkInfo _networkInfo;

  SyncStatusNotifier(this._networkInfo) : super(const SyncStatusState()) {
    _init();
  }

  void _init() async {
    final isConnected = await _networkInfo.isConnected;
    state = state.copyWith(
      status: isConnected ? SyncStatus.synced : SyncStatus.offline,
    );
    
    _networkInfo.onConnectivityChanged.listen((isConnected) {
      if (isConnected && state.pendingCount > 0) {
        state = state.copyWith(status: SyncStatus.pending);
      } else if (isConnected) {
        state = state.copyWith(status: SyncStatus.synced);
      } else {
        state = state.copyWith(status: SyncStatus.offline);
      }
    });
  }

  void updatePendingCount(int count) {
    state = state.copyWith(
      pendingCount: count,
      status: count > 0 ? SyncStatus.pending : SyncStatus.synced,
    );
  }

  void setSyncing(bool syncing) {
    state = state.copyWith(isSyncing: syncing);
  }

  void syncComplete() {
    state = state.copyWith(
      status: SyncStatus.synced,
      pendingCount: 0,
      isSyncing: false,
      lastSyncTime: DateTime.now(),
    );
  }

  void syncFailed() {
    state = state.copyWith(
      status: SyncStatus.failed,
      isSyncing: false,
    );
  }
}
// === ARCHIVO: lib/injection_container.dart ===
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'core/network/network_info.dart';
import 'core/constants/app_constants.dart';
import 'core/database/app_database.dart';
import 'data/datasources/local/transaction_local_datasource.dart';
import 'data/datasources/remote/transaction_remote_datasource.dart';
import 'data/repositories/transaction_repository_impl.dart';
import 'domain/repositories/transaction_repository.dart';
import 'domain/usecases/save_transaction.dart';
import 'domain/usecases/get_pending_transactions.dart';
import 'domain/usecases/sync_transactions.dart';
import 'domain/usecases/get_all_transactions.dart';
import 'presentation/bloc/transaction_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoC
  sl.registerFactory(
    () => TransactionBloc(
      saveTransaction: sl(),
      getPendingTransactions: sl(),
      syncTransactions: sl(),
      getAllTransactions: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SaveTransaction(sl()));
  sl.registerLazySingleton(() => GetPendingTransactions(sl()));
  sl.registerLazySingleton(() => SyncTransactions(sl()));
  sl.registerLazySingleton(() => GetAllTransactions(sl()));

  // Repository
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<TransactionLocalDataSource>(
    () => TransactionLocalDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionRemoteDataSourceImpl(sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(Connectivity()),
  );

  sl.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout: const Duration(milliseconds: AppConstants.connectionTimeoutMs),
        receiveTimeout: const Duration(milliseconds: AppConstants.receiveTimeoutMs),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-API-Version': AppConstants.apiVersion,
        },
      ),
    );

    dio.interceptors.addAll([
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => print('DIO: $obj'),
      ),
      _AuthInterceptor(sl()),
    ]);

    return dio;
  });

  // External
  sl.registerLazySingleton(() => const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  ));

  // Database
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase(sl()));

  await _initDatabase();
  await _initSecureStorage();
}

Future<void> _initDatabase() async {
  final database = sl<AppDatabase>();
  await database.initialize();
}

Future<void> _initSecureStorage() async {
  const storage = FlutterSecureStorage();
  final lastSync = await storage.read(key: AppConstants.secureStorageKeyLastSync);
  if (lastSync == null) {
    await storage.write(
      key: AppConstants.secureStorageKeyLastSync,
      value: DateTime.now().toIso8601String(),
    );
  }
}

class _AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _secureStorage;

  _AuthInterceptor(this._secureStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _secureStorage.read(key: AppConstants.secureStorageKeyUserToken);
    final userId = await _secureStorage.read(key: AppConstants.secureStorageKeyUserId);

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    if (userId != null) {
      options.headers['X-User-ID'] = userId;
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      _secureStorage.delete(key: AppConstants.secureStorageKeyUserToken);
    }
    handler.next(err);
  }
}

// Providers for Riverpod integration
final transactionBlocProvider = Provider<TransactionBloc>((ref) {
  return sl<TransactionBloc>();
});

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return sl<NetworkInfo>();
});

final transactionRepositoryProvider = Provider<TransactionRepository>((ref) {
  return sl<TransactionRepository>();
});

final dioProvider = Provider<Dio>((ref) {
  return sl<Dio>();
});

final databaseProvider = Provider<AppDatabase>((ref) {
  return sl<AppDatabase>();
});

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return sl<FlutterSecureStorage>();
});

// Clean up function
Future<void> dispose() async {
  await sl<AppDatabase>().close();
  sl.reset();
}
// === ARCHIVO: test/data/repositories/transaction_repository_impl_test.dart ===
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:payment_app/core/error/exceptions.dart';
import 'package:payment_app/core/error/failures.dart';
import 'package:payment_app/core/network/network_info.dart';
import 'package:payment_app/data/datasources/local/transaction_local_datasource.dart';
import 'package:payment_app/data/datasources/remote/transaction_remote_datasource.dart';
import 'package:payment_app/data/models/transaction_model.dart';
import 'package:payment_app/data/repositories/transaction_repository_impl.dart';
import 'package:payment_app/domain/entities/transaction.dart';

import 'transaction_repository_impl_test.mocks.dart';

@GenerateMocks([
  TransactionLocalDataSource,
  TransactionRemoteDataSource,
  NetworkInfo,
])
void main() {
  late TransactionRepositoryImpl repository;
  late MockTransactionLocalDataSource mockLocalDataSource;
  late MockTransactionRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalDataSource = MockTransactionLocalDataSource();
    mockRemoteDataSource = MockTransactionRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = TransactionRepositoryImpl(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('saveTransaction', () {
    const tTransactionModel = TransactionModel(
      id: 'test-id-123',
      amount: 100.50,
      recipientId: 'recipient-456',
      recipientName: 'John Doe',
      description: 'Test transaction',
      status: 'pending',
      createdAt: '2024-01-15T10:30:00Z',
      updatedAt: '2024-01-15T10:30:00Z',
    );

    test('should save transaction locally when device is offline', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDataSource.saveTransaction(tTransactionModel))
          .thenAnswer((_) async => tTransactionModel);

      final result = await repository.saveTransaction(tTransactionModel);

      expect(result, isA<Right<Failure, Transaction>>());
      verify(mockLocalDataSource.saveTransaction(tTransactionModel)).called(1);
      verifyNever(mockRemoteDataSource.saveTransaction(any));
    });

    test('should save transaction remotely when device is online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.saveTransaction(tTransactionModel))
          .thenAnswer((_) async => tTransactionModel);

      final result = await repository.saveTransaction(tTransactionModel);

      expect(result, isA<Right<Failure, Transaction>>());
      verify(mockRemoteDataSource.saveTransaction(tTransactionModel)).called(1);
      verifyNever(mockLocalDataSource.saveTransaction(any));
    });

    test('should fallback to local save when remote save fails', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.saveTransaction(tTransactionModel))
          .thenThrow(const ServerException(
        message: 'Server error',
        statusCode: 500,
      ));
      when(mockLocalDataSource.saveTransaction(tTransactionModel))
          .thenAnswer((_) async => tTransactionModel);

      final result = await repository.saveTransaction(tTransactionModel);

      expect(result, isA<Right<Failure, Transaction>>());
      verify(mockRemoteDataSource.saveTransaction(tTransactionModel)).called(1);
      verify(mockLocalDataSource.saveTransaction(tTransactionModel)).called(1);
    });

    test('should return CacheFailure when local save fails offline', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(mockLocalDataSource.saveTransaction(tTransactionModel))
          .thenThrow(const CacheException(
        message: 'Failed to save',
        operation: 'save',
      ));

      final result = await repository.saveTransaction(tTransactionModel);

      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });

  group('getPendingTransactions', () {
    final tTransactionModels = [
      const TransactionModel(
        id: 'pending-1',
        amount: 50.00,
        recipientId: 'recipient-1',
        recipientName: 'Alice',
        description: 'First pending',
        status: 'pending',
        createdAt: '2024-01-15T10:00:00Z',
        updatedAt: '2024-01-15T10:00:00Z',
      ),
      const TransactionModel(
        id: 'pending-2',
        amount: 75.00,
        recipientId: 'recipient-2',
        recipientName: 'Bob',
        description: 'Second pending',
        status: 'pending',
        createdAt: '2024-01-15T11:00:00Z',
        updatedAt: '2024-01-15T11:00:00Z',
      ),
    ];

    test('should get pending transactions from local data source', () async {
      when(mockLocalDataSource.getPendingTransactions())
          .thenAnswer((_) async => tTransactionModels);

      final result = await repository.getPendingTransactions();

      expect(result, isA<Right<Failure, List<Transaction>>>());
      verify(mockLocalDataSource.getPendingTransactions()).called(1);
    });

    test('should return CacheFailure when local data source throws', () async {
      when(mockLocalDataSource.getPendingTransactions())
          .thenThrow(const CacheException(
        message: 'Read error',
        operation: 'read',
      ));

      final result = await repository.getPendingTransactions();

      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });

  group('syncTransactions', () {
    final tPendingTransactions = [
      const TransactionModel(
        id: 'sync-1',
        amount: 100.00,
        recipientId: 'recipient-sync-1',
        recipientName: 'Sync User 1',
        description: 'Transaction to sync 1',
        status: 'pending',
        createdAt: '2024-01-15T09:00:00Z',
        updatedAt: '2024-01-15T09:00:00Z',
      ),
      const TransactionModel(
        id: 'sync-2',
        amount: 200.00,
        recipientId: 'recipient-sync-2',
        recipientName: 'Sync User 2',
        description: 'Transaction to sync 2',
        status: 'pending',
        createdAt: '2024-01-15T09:30:00Z',
        updatedAt: '2024-01-15T09:30:00Z',
      ),
    ];

    test('should sync all pending transactions when online', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockLocalDataSource.getPendingTransactions())
          .thenAnswer((_) async => tPendingTransactions);
      
      for (final transaction in tPendingTransactions) {
        when(mockRemoteDataSource.syncTransaction(transaction))
            .thenAnswer((_) async => transaction.copyWith(status: 'synced'));
        when(mockLocalDataSource.updateTransaction(any))
            .thenAnswer((_) async {});
      }

      final result = await repository.syncTransactions();

      expect(result, isA<Right<Failure, List<Transaction>>>());
      verify(mockRemoteDataSource.syncTransaction(any))
          .called(tPendingTransactions.length);
    });

    test('should return NetworkFailure when device is offline', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.syncTransactions();

      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Should return failure'),
      );
      verifyNever(mockRemoteDataSource.syncTransaction(any));
    });

    test('should handle partial sync failure gracefully', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockLocalDataSource.getPendingTransactions())
          .thenAnswer((_) async => tPendingTransactions);

      when(mockRemoteDataSource.syncTransaction(tPendingTransactions[0]))
          .thenAnswer(
            (_) async => tPendingTransactions[0].copyWith(status: 'synced'),
          );
      when(mockRemoteDataSource.syncTransaction(tPendingTransactions[1]))
          .thenThrow(const ServerException(
        message: 'Sync failed for second transaction',
        statusCode: 500,
      ));

      when(mockLocalDataSource.updateTransaction(any))
          .thenAnswer((_) async {});

      final result = await repository.syncTransactions();

      result.fold(
        (failure) {
          expect(failure, isA<SyncFailure>());
        },
        (_) => fail('Should return failure for partial sync'),
      );
    });

    test('should update local transaction after successful sync', () async {
      final syncedTransaction = tPendingTransactions[0].copyWith(status: 'synced');
      
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockLocalDataSource.getPendingTransactions())
          .thenAnswer((_) async => [tPendingTransactions[0]]);
      when(mockRemoteDataSource.syncTransaction(tPendingTransactions[0]))
          .thenAnswer((_) async => syncedTransaction);
      when(mockLocalDataSource.updateTransaction(syncedTransaction))
          .thenAnswer((_) async {});

      await repository.syncTransactions();

      verify(mockLocalDataSource.updateTransaction(syncedTransaction)).called(1);
    });
  });

  group('getAllTransactions', () {
    final tAllTransactions = [
      const TransactionModel(
        id: 'all-1',
        amount: 100.00,
        recipientId: 'recipient-all-1',
        recipientName: 'All User 1',
        description: 'First transaction',
        status: 'synced',
        createdAt: '2024-01-14T10:00:00Z',
        updatedAt: '2024-01-14T12:00:00Z',
      ),
      const TransactionModel(
        id: 'all-2',
        amount: 150.00,
        recipientId: 'recipient-all-2',
        recipientName: 'All User 2',
        description: 'Second transaction',
        status: 'pending',
        createdAt: '2024-01-15T08:00:00Z',
        updatedAt: '2024-01-15T08:00:00Z',
      ),
    ];

    test('should get all transactions from local data source', () async {
      when(mockLocalDataSource.getAllTransactions())
          .thenAnswer((_) async => tAllTransactions);

      final result = await repository.getAllTransactions();

      expect(result, isA<Right<Failure, List<Transaction>>>());
      verify(mockLocalDataSource.getAllTransactions()).called(1);
    });

    test('should return CacheFailure when local data source fails', () async {
      when(mockLocalDataSource.getAllTransactions())
          .thenThrow(const CacheException(
        message: 'Database error',
        operation: 'read_all',
      ));

      final result = await repository.getAllTransactions();

      result.fold(
        (failure) => expect(failure, isA<CacheFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });

  group('network connectivity', () {
    test('should check network connectivity before remote operations', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.saveTransaction(any))
          .thenAnswer((_) async => const TransactionModel(
                id: 'test',
                amount: 100,
                recipientId: 'r',
                recipientName: 'Test',
                description: 'Test',
                status: 'synced',
                createdAt: '2024-01-15T10:00:00Z',
                updatedAt: '2024-01-15T10:00:00Z',
              ));

      await repository.saveTransaction(const TransactionModel(
        id: 'test',
        amount: 100,
        recipientId: 'r',
        recipientName: 'Test',
        description: 'Test',
        status: 'pending',
        createdAt: '2024-01-15T10:00:00Z',
        updatedAt: '2024-01-15T10:00:00Z',
      ));

      verify(mockNetworkInfo.isConnected).called(1);
    });
  });
}

// === ARCHIVO: lib/data/datasources/local/transaction_local_datasource.dart ===
import 'dart:async';
import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/constants/app_constants.dart';
import '../../models/transaction_model.dart';

abstract class TransactionLocalDataSource {
  Future<List<TransactionModel>> getPendingTransactions();
  Future<List<TransactionModel>> getAllTransactions();
  Future<TransactionModel?> getTransactionById(String id);
  Future<void> saveTransaction(TransactionModel transaction);
  Future<void> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
  Future<int> getPendingTransactionsCount();
  Future<void> markAsSynced(String id, DateTime syncedAt);
  Future<void> markAsFailed(String id, String reason);
  Future<void> incrementRetryCount(String id);
  Future<void> clearAllTransactions();
  Future<TransactionModel> cacheTransaction(TransactionModel transaction);
  Future<void> cacheTransactions(List<TransactionModel> transactions);
  Future<List<TransactionModel>> getCachedTransactions();
  Future<void> updateTransactionStatus(String id, String status, {String? errorMessage});
}

class TransactionLocalDataSourceImpl implements TransactionLocalDataSource {
  final AppDatabase database;

  TransactionLocalDataSourceImpl({required this.database});

  @override
  Future<List<TransactionModel>> getPendingTransactions() async {
    try {
      final pending = await database.getPendingTransactions();
      return pending.map(_mapToModel).toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get pending transactions: $e',
        operation: 'getPendingTransactions',
      );
    }
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    try {
      final all = await database.getAllTransactions();
      return all.map(_mapToModel).toList();
    } catch (e) {
      throw CacheException(
        message: 'Failed to get all transactions: $e',
        operation: 'getAllTransactions',
      );
    }
  }

  @override
  Future<TransactionModel?> getTransactionById(String id) async {
    try {
      final transaction = await database.getTransactionById(id);
      return transaction != null ? _mapToModel(transaction) : null;
    } catch (e) {
      throw CacheException(
        message: 'Failed to get transaction by id: $e',
        operation: 'getTransactionById',
      );
    }
  }

  @override
  Future<void> saveTransaction(TransactionModel transaction) async {
    try {
      final pendingCount = await getPendingTransactionsCount();
      if (pendingCount >= AppConstants.maxOfflineTransactions) {
        throw OfflineLimitException(
          currentCount: pendingCount,
          maxAllowed: AppConstants.maxOfflineTransactions,
        );
      }
      final companion = TransactionsCompanion.insert(
        id: transaction.id,
        amount: transaction.amount,
        recipientId: transaction.recipientId,
        recipientName: transaction.recipientName,
        description: Value(transaction.description),
        createdAt: transaction.createdAt,
        syncedAt: Value(transaction.syncedAt),
        status: transaction.status,
        failureReason: Value(transaction.failureReason),
        retryCount: transaction.retryCount,
      );
      await database.insertTransaction(companion);
    } on OfflineLimitException {
      rethrow;
    } catch (e) {
      throw CacheException(
        message: 'Failed to save transaction: $e',
        operation: 'saveTransaction',
      );
    }
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      final companion = TransactionsCompanion(
        id: Value(transaction.id),
        amount: Value(transaction.amount),
        recipientId: Value(transaction.recipientId),
        recipientName: Value(transaction.recipientName),
        description: Value(transaction.description),
        createdAt: Value(transaction.createdAt),
        syncedAt: Value(transaction.syncedAt),
        status: Value(transaction.status),
        failureReason: Value(transaction.failureReason),
        retryCount: Value(transaction.retryCount),
      );
      await database.updateTransactionStatus(
        transaction.id,
        transaction.status,
        failureReason: transaction.failureReason,
      );
    } catch (e) {
      throw CacheException(
        message: 'Failed to update transaction: $e',
        operation: 'updateTransaction',
      );
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    try {
      await database.deleteTransaction(id);
    } catch (e) {
      throw CacheException(
        message: 'Failed to delete transaction: $e',
        operation: 'deleteTransaction',
      );
    }
  }

  @override
  Future<int> getPendingTransactionsCount() async {
    try {
      return await database.getPendingTransactionCount();
    } catch (e) {
      throw CacheException(
        message: 'Failed to count pending transactions: $e',
        operation: 'getPendingTransactionsCount',
      );
    }
  }

  @override
  Future<void> markAsSynced(String id, DateTime syncedAt) async {
    try {
      await database.updateTransactionStatus(id, AppConstants.syncedStatus);
    } catch (e) {
      throw CacheException(
        message: 'Failed to mark transaction as synced: $e',
        operation: 'markAsSynced',
      );
    }
  }

  @override
  Future<void> markAsFailed(String id, String reason) async {
    try {
      await database.updateTransactionStatus(id, AppConstants.failedStatus, failureReason: reason);
    } catch (e) {
      throw CacheException(
        message: 'Failed to mark transaction as failed: $e',
        operation: 'markAsFailed',
      );
    }
  }

  @override
  Future<void> incrementRetryCount(String id) async {
    try {
      final transaction = await getTransactionById(id);
      if (transaction != null) {
        await database.updateTransactionStatus(id, transaction.status, retryCount: transaction.retryCount + 1);
      }
    } catch (e) {
      throw CacheException(
        message: 'Failed to increment retry count: $e',
        operation: 'incrementRetryCount',
      );
    }
  }

  @override
  Future<void> clearAllTransactions() async {
    try {
      await database.clearAllData();
    } catch (e) {
      throw CacheException(
        message: 'Failed to clear all transactions: $e',
        operation: 'clearAllTransactions',
      );
    }
  }

  @override
  Future<TransactionModel> cacheTransaction(TransactionModel transaction) async {
    await saveTransaction(transaction);
    return transaction;
  }

  @override
  Future<void> cacheTransactions(List<TransactionModel> transactions) async {
    for (final transaction in transactions) {
      await saveTransaction(transaction);
    }
  }

  @override
  Future<List<TransactionModel>> getCachedTransactions() async {
    return getAllTransactions();
  }

  @override
  Future<void> updateTransactionStatus(String id, String status, {String? errorMessage}) async {
    try {
      await database.updateTransactionStatus(id, status, failureReason: errorMessage);
    } catch (e) {
      throw CacheException(
        message: 'Failed to update transaction status: $e',
        operation: 'updateTransactionStatus',
      );
    }
  }

  TransactionModel _mapToModel(Transaction row) {
    return TransactionModel(
      id: row.id,
      amount: row.amount,
      recipientId: row.recipientId,
      recipientName: row.recipientName,
      description: row.description,
      createdAt: row.createdAt,
      syncedAt: row.syncedAt,
      status: row.status,
      failureReason: row.failureReason,
      retryCount: row.retryCount,
    );
  }
}

// === ARCHIVO: lib/data/datasources/remote/transaction_remote_datasource.dart ===
abstract class TransactionRemoteDataSource {
  Future<List<TransactionModel>> fetchTransactions();
  Future<TransactionModel> createTransaction(TransactionModel transaction);
  Future<TransactionModel> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
  Future<bool> checkServerHealth();
  Future<List<TransactionModel>> getAllTransactions();
  Future<TransactionModel> getTransactionById(String id);
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final Dio dio;

  TransactionRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<TransactionModel>> fetchTransactions() async {
    try {
      final response = await dio.get('/transactions');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((json) => TransactionModel.fromJson(json as Map<String, dynamic>)).toList();
      }
      throw ServerException(
        message: 'Failed to fetch transactions',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<TransactionModel> createTransaction(TransactionModel transaction) async {
    try {
      final response = await dio.post('/transactions', data: transaction.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        return TransactionModel.fromJson(response.data as Map<String, dynamic>);
      }
      throw ServerException(
        message: 'Failed to create transaction',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<TransactionModel> updateTransaction(TransactionModel transaction) async {
    try {
      final response = await dio.put('/transactions/${transaction.id}', data: transaction.toJson());
      if (response.statusCode == 200) {
        return TransactionModel.fromJson(response.data as Map<String, dynamic>);
      }
      throw ServerException(
        message: 'Failed to update transaction',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    try {
      final response = await dio.delete('/transactions/$id');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(
          message: 'Failed to delete transaction',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<bool> checkServerHealth() async {
    try {
      final response = await dio.get('/health');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    return fetchTransactions();
  }

  @override
  Future<TransactionModel> getTransactionById(String id) async {
    try {
      final response = await dio.get('/transactions/$id');
      if (response.statusCode == 200) {
        return TransactionModel.fromJson(response.data as Map<String, dynamic>);
      }
      throw ServerException(
        message: 'Transaction not found',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  ServerException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ServerException(
          message: 'Connection timeout',
          statusCode: 408,
        );
      case DioExceptionType.badResponse:
        return ServerException(
          message: e.response?.statusMessage ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.connectionError:
        return ServerException(
          message: 'No internet connection',
          statusCode: null,
        );
      default:
        return ServerException(
          message: e.message ?? 'Unknown error',
          statusCode: null,
        );
    }
  }
}

// === ARCHIVO: lib/domain/repositories/transaction_repository.dart ===
package payment_app.domain.repositories;
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/transaction.dart';

abstract class TransactionRepository {
  Future<Either<Failure, Transaction>> saveTransaction(Transaction transaction);
  Future<Either<Failure, Transaction>> getTransactionById(String id);
  Future<Either<Failure, List<Transaction>>> getAllTransactions();
  Future<Either<Failure, List<Transaction>>> getPendingTransactions();
  Future<Either<Failure, List<Transaction>>> getFailedTransactions();
  Future<Either<Failure, Transaction>> updateTransaction(Transaction transaction);
  Future<Either<Failure, void>> deleteTransaction(String id);
  Future<Either<Failure, int>> getPendingTransactionCount();
  Future<Either<Failure, SyncResult>> syncPendingTransactions();
  Future<Either<Failure, Transaction>> retryFailedTransaction(String id);
  Future<Either<Failure, void>> clearAllTransactions();
  Future<Either<Failure, void>> clearSyncedTransactions();
  Future<Either<Failure, Transaction>> syncTransaction(Transaction transaction);
  Future<Either<Failure, void>> updateTransactionStatus(String id, String status, {String? errorMessage});
}

class SyncResult {
  final int syncedCount;
  final int failedCount;
  final List<String> failedTransactionIds;

  const SyncResult({
    required this.syncedCount,
    required this.failedCount,
    this.failedTransactionIds = const [],
  });
}

// === ARCHIVO: lib/data/repositories/transaction_repository_impl.dart ===
package data.repositories;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/local/transaction_local_datasource.dart';
import '../datasources/remote/transaction_remote_datasource.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionLocalDataSource localDataSource;
  final TransactionRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TransactionRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Transaction>> saveTransaction(Transaction transaction) async {
    try {
      final isConnected = await networkInfo.isConnected;
      
      if (isConnected) {
        final remoteModel = _toRemoteModel(transaction);
        final syncedTransaction = await remoteDataSource.createTransaction(remoteModel);
        await localDataSource.cacheTransaction(syncedTransaction);
        return Right(_toEntity(syncedTransaction));
      } else {
        final pendingCount = await localDataSource.getPendingTransactionsCount();
        if (pendingCount >= 100) {
          return const Left(SyncFailure.offlineLimitReached(100));
        }
        final localModel = _toLocalModel(transaction);
        final savedTransaction = await localDataSource.cacheTransaction(localModel);
        return Right(_toEntity(savedTransaction));
      }
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure.writeError());
    } on NetworkException catch (e) {
      return Left(NetworkFailure.unknown(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getAllTransactions() async {
    try {
      final isConnected = await networkInfo.isConnected;
      
      if (isConnected) {
        final remoteTransactions = await remoteDataSource.getAllTransactions();
        await localDataSource.cacheTransactions(remoteTransactions);
        return Right(remoteTransactions.map(_toEntity).toList());
      } else {
        final localTransactions = await localDataSource.getCachedTransactions();
        return Right(localTransactions.map(_toEntity).toList());
      }
    } on CacheException catch (e) {
      return Left(CacheFailure.readError());
    } on ServerException catch (e) {
      final localTransactions = await localDataSource.getCachedTransactions();
      if (localTransactions.isNotEmpty) {
        return Right(localTransactions.map(_toEntity).toList());
      }
      return Left(ServerFailure.fromStatusCode(e.statusCode ?? 500));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getPendingTransactions() async {
    try {
      final pendingTransactions = await localDataSource.getPendingTransactions();
      return Right(pendingTransactions.map(_toEntity).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure.readError());
    } catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<Transaction>>> getFailedTransactions() async {
    try {
      final failedTransactions = await localDataSource.getAllTransactions();
      final filtered = failedTransactions.where((t) => t.status == 'failed').toList();
      return Right(filtered.map(_toEntity).toList());
    } on CacheException catch (e) {
      return Left(CacheFailure.readError());
    } catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, SyncResult>> syncTransactions() async {
    try {
      final isConnected = await networkInfo.isConnected;
      
      if (!isConnected) {
        return const Left(NetworkFailure.noConnection());
      }

      final pendingTransactions = await localDataSource.getPendingTransactions();
      
      if (pendingTransactions.isEmpty) {
        return const Right(SyncResult(syncedCount: 0, failedCount: 0));
      }

      int syncedCount = 0;
      int failedCount = 0;
      final failedIds = <String>[];

      for (final transaction in pendingTransactions) {
        try {
          final remoteModel = _toRemoteModel(_toEntity(transaction));
          await remoteDataSource.createTransaction(remoteModel);
          await localDataSource.updateTransactionStatus(transaction.id, 'synced');
          syncedCount++;
        } on ServerException catch (e) {
          await localDataSource.updateTransactionStatus(transaction.id, 'failed', errorMessage: e.message);
          failedCount++;
          failedIds.add(transaction.id);
        } catch (e) {
          failedCount++;
          failedIds.add(transaction.id);
        }
      }

      if (failedCount > 0 && syncedCount == 0) {
        return Left(SyncFailure.partialFailure(syncedCount, failedCount));
      }

      return Right(SyncResult(syncedCount: syncedCount, failedCount: failedCount, failedTransactionIds: failedIds));
    } on NetworkException catch (e) {
      return Left(NetworkFailure.unknown(e.message));
    } catch (e) {
      return Left(SyncFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> getTransactionById(String id) async {
    try {
      final isConnected = await networkInfo.isConnected;
      
      if (isConnected) {
        try {
          final remoteTransaction = await remoteDataSource.getTransactionById(id);
          await localDataSource.cacheTransaction(remoteTransaction);
          return Right(_toEntity(remoteTransaction));
        } on ServerException {
          final localTransaction = await localDataSource.getTransactionById(id);
          if (localTransaction != null) {
            return Right(_toEntity(localTransaction));
          }
          return Left(CacheFailure.notFound());
        }
      } else {
        final localTransaction = await localDataSource.getTransactionById(id);
        if (localTransaction != null) {
          return Right(_toEntity(localTransaction));
        }
        return Left(CacheFailure.notFound());
      }
    } on CacheException catch (e) {
      return Left(CacheFailure.notFound());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(String id) async {
    try {
      final isConnected = await networkInfo.isConnected;
      
      if (isConnected) {
        await remoteDataSource.deleteTransaction(id);
      }
      await localDataSource.deleteTransaction(id);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure.fromStatusCode(e.statusCode ?? 500));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getPendingTransactionCount() async {
    try {
      final count = await localDataSource.getPendingTransactionsCount();
      return Right(count);
    } on CacheException catch (e) {
      return Left(CacheFailure.readError());
    } catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Transaction>> syncTransaction(Transaction transaction) async {
    try {
      final isConnected = await networkInfo.isConnected;
      
      if (!isConnected) {
        return const Left(NetworkFailure.noConnection());
      }

      final remoteModel = _toRemoteModel(transaction);
      final syncedModel = await remoteDataSource.createTransaction(remoteModel);
      await localDataSource.markAsSynced(transaction.id, DateTime.now());
      return Right(_toEntity(syncedModel));
    } on ServerException catch (e) {
      await localDataSource.markAsFailed(transaction.id, e.message);
      return Left(ServerFailure.fromStatusCode(e.statusCode ?? 500));
    } on NetworkException catch (e) {
      return Left(NetworkFailure.unknown(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateTransactionStatus(String id, String status, {String? errorMessage}) async {
    try {
      if (status == 'synced') {
        await localDataSource.markAsSynced(id, DateTime.now());
      } else if (status == 'failed') {
        await localDataSource.markAsFailed(id, errorMessage ?? 'Unknown error');
      } else {
        await localDataSource.updateTransactionStatus(id, status, errorMessage: errorMessage);
      }
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Transaction>> retryFailedTransaction(String id) async {
    try {
      final isConnected = await networkInfo.isConnected;
      
      if (!isConnected) {
        return const Left(NetworkFailure.noConnection());
      }

      final transaction = await localDataSource.getTransactionById(id);
      if (transaction == null) {
        return Left(CacheFailure.notFound());
      }

      final remoteModel = _toRemoteModel(_toEntity(transaction));
      final syncedModel = await remoteDataSource.createTransaction(remoteModel);
      await localDataSource.markAsSynced(id, DateTime.now());
      return Right(_toEntity(syncedModel));
    } on ServerException catch (e) {
      await localDataSource.markAsFailed(id, e.message);
      return Left(ServerFailure.fromStatusCode(e.statusCode ?? 500));
    } on NetworkException catch (e) {
      return Left(NetworkFailure.unknown(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearAllTransactions() async {
    try {
      await localDataSource.clearAllTransactions();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearSyncedTransactions() async {
    try {
      final allTransactions = await localDataSource.getAllTransactions();
      final syncedIds = allTransactions.where((t) => t.status == 'synced').map((t) => t.id).toList();
      for (final id in syncedIds) {
        await localDataSource.deleteTransaction(id);
      }
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  Transaction _toEntity(TransactionModel model) {
    return Transaction(
      id: model.id,
      amount: model.amount,
      recipientId: model.recipientId,
      recipientName: model.recipientName,
      status: model.status,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      description: model.description,
    );
  }

  TransactionModel _toLocalModel(Transaction entity) {
    return TransactionModel(
      id: entity.id,
      amount: entity.amount,
      recipientId: entity.recipientId,
      recipientName: entity.recipientName,
      status: 'pending',
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      description: entity.description,
    );
  }

  TransactionModel _toRemoteModel(Transaction entity) {
    return TransactionModel(
      id: entity.id,
      amount: entity.amount,
      recipientId: entity.recipientId,
      recipientName: entity.recipientName,
      status: entity.status,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      description: entity.description,
    );
  }
}

// === ARCHIVO: lib/domain/usecases/sync_transactions.dart ===
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/error/exceptions.dart';
import '../../core/constants/app_constants.dart';
import '../../core/network/network_info.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class SyncTransactions {
  final TransactionRepository repository;
  final NetworkInfo networkInfo;

  SyncTransactions({
    required this.repository,
    required this.networkInfo,
  });

  Future<Either<Failure, SyncResult>> call({
    List<String>? transactionIds,
    bool forceSync = false,
  }) async {
    try {
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return Left(NetworkFailure.noConnection());
      }

      final pendingResult = await repository.getPendingTransactions();

      final pendingTransactions = pendingResult.fold(
        (failure) => <Transaction>[],
        (transactions) => transactions.where((t) => t.status == 'pending').toList(),
      );

      if (pendingTransactions.isEmpty) {
        return const Right(SyncResult(
          syncedCount: 0,
          failedCount: 0,
          totalCount: 0,
        ));
      }

      final targetIds = transactionIds ?? pendingTransactions.map((t) => t.id).toList();
      final toSync = pendingTransactions
          .where((t) => targetIds.contains(t.id))
          .toList();

      int syncedCount = 0;
      int failedCount = 0;
      final failedIds = <String>[];

      for (final transaction in toSync) {
        try {
          final syncResult = await repository.syncTransaction(transaction);
          
          await syncResult.fold(
            (failure) async {
              failedCount++;
              failedIds.add(transaction.id);
              await repository.updateTransactionStatus(
                transaction.id,
                'failed',
                errorMessage: failure.message,
              );
            },
            (syncedTransaction) async {
              syncedCount++;
              await repository.updateTransactionStatus(
                transaction.id,
                'synced',
              );
            },
          );
        } on SyncException catch (e) {
          failedCount++;
          failedIds.add(transaction.id);
          await repository.updateTransactionStatus(
            transaction.id,
            'failed',
            errorMessage: e.message,
          );
        } catch (e) {
          failedCount++;
          failedIds.add(transaction.id);
        }
      }

      if (failedCount > 0 && syncedCount == 0) {
        return Left(SyncFailure.partialFailure(syncedCount, failedCount));
      }

      return Right(SyncResult(
        syncedCount: syncedCount,
        failedCount: failedCount,
        totalCount: toSync.length,
        failedTransactionIds: failedIds,
      ));
    } on NetworkException catch (e) {
      return Left(NetworkFailure.unknown(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure.fromStatusCode(e.statusCode ?? 500));
    } catch (e) {
      return Left(SyncFailure(
        message: 'Sync process failed: $e',
      ));
    }
  }

  Future<Either<Failure, SyncResult>> syncAllPending() async {
    return call(forceSync: true);
  }

  Future<Either<Failure, SyncResult>> syncByIds(List<String> ids) async {
    if (ids.isEmpty) {
      return const Right(SyncResult(
        syncedCount: 0,
        failedCount: 0,
        totalCount: 0,
      ));
    }
    return call(transactionIds: ids);
  }

  Future<Either<Failure, bool>> canSyncMore() async {
    try {
      final pendingResult = await repository.getPendingTransactions();
      return pendingResult.fold(
        (failure) => Left(failure),
        (transactions) {
          final pendingCount = transactions.where((t) => t.status == 'pending').length;
          final canSync = pendingCount < AppConstants.maxOfflineTransactions;
          return Right<Failure, bool>(canSync);
        },
      );
    } catch (e) {
      return Left(CacheFailure(message: 'Cannot check sync capacity: $e'));
    }
  }

  Future<Either<Failure, SyncStatistics>> getSyncStatistics() async {
    try {
      final allResult = await repository.getAllTransactions();
      return allResult.fold(
        (failure) => Left(failure),
        (transactions) {
          final pending = transactions.where((t) => t.status == 'pending').length;
          final synced = transactions.where((t) => t.status == 'synced').length;
          final failed = transactions.where((t) => t.status == 'failed').length;
          final pendingTotal = transactions
              .where((t) => t.status == 'pending')
              .fold<double>(0.0, (sum, t) => sum + t.amount);
          
          return Right(SyncStatistics(
            pendingCount: pending,
            syncedCount: synced,
            failedCount: failed,
            pendingTotalAmount: pendingTotal,
          ));
        },
      );
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get sync statistics: $e'));
    }
  }
}

class SyncResult {
  final int syncedCount;
  final int failedCount;
  final int totalCount;
  final List<String> failedTransactionIds;
  final DateTime syncedAt;

  SyncResult({
    required this.syncedCount,
    required this.failedCount,
    required this.totalCount,
    List<String>? failedTransactionIds,
    DateTime? syncedAt,
  })  : failedTransactionIds = failedTransactionIds ?? [],
        syncedAt = syncedAt ?? DateTime.now();

  bool get hasFailures => failedCount > 0;
  bool get isFullySuccessful => failedCount == 0 && syncedCount > 0;
  double get successRate => totalCount > 0 ? syncedCount / totalCount : 0.0;
}

class SyncStatistics {
  final int pendingCount;
  final int syncedCount;
  final int failedCount;
  final double pendingTotalAmount;

  SyncStatistics({
    required this.pendingCount,
    required this.syncedCount,
    required this.failedCount,
    required this.pendingTotalAmount,
  });

  int get totalCount => pendingCount + syncedCount + failedCount;
  double get syncProgress => totalCount > 0 ? syncedCount / totalCount : 0.0;
}


// === ARCHIVO: lib/domain/usecases/save_transaction.dart ===
package payment_app.domain.usecases;

import 'package:dartz/dartz.dart';
import 'package:payment_app/core/error/failures.dart';
import 'package:payment_app/core/network/network_info.dart';
import 'package:payment_app/domain/entities/transaction.dart';
import 'package:payment_app/domain/repositories/transaction_repository.dart';

class SaveTransaction {
  final TransactionRepository repository;
  final NetworkInfo networkInfo;
  
  SaveTransaction(this.repository, this.networkInfo);
  
  Future<Either<Failure, Transaction>> call(Transaction transaction) async {
    return execute(transaction);
  }
  
  Future<Either<Failure, Transaction>> execute(Transaction transaction) async {
    final isConnected = await networkInfo.isConnected;
    
    if (isConnected) {
      return await repository.saveTransaction(transaction);
    } else {
      return await repository.saveTransaction(transaction);
    }
  }
}

```
