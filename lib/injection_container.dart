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