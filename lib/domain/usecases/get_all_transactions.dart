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