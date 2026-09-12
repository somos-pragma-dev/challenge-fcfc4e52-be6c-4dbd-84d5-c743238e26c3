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