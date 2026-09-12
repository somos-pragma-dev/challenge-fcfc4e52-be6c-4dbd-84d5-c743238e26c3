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