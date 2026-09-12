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