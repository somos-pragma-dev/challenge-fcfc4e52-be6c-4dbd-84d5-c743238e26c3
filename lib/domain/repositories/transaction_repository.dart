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