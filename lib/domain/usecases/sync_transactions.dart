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