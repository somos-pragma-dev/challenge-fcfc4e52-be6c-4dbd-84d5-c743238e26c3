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