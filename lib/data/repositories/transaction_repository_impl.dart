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