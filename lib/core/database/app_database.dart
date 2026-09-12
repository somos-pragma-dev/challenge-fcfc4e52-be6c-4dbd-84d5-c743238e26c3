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