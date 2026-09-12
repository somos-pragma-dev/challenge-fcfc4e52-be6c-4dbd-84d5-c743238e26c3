import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/usecases/save_transaction.dart';
import '../../domain/usecases/get_pending_transactions.dart';
import '../../domain/usecases/sync_transactions.dart';
import '../../domain/usecases/get_all_transactions.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends StateNotifier<TransactionState> {
  final SaveTransaction saveTransaction;
  final GetPendingTransactions getPendingTransactions;
  final SyncTransactions syncTransactions;
  final GetAllTransactions getAllTransactions;

  TransactionBloc({
    required this.saveTransaction,
    required this.getPendingTransactions,
    required this.syncTransactions,
    required this.getAllTransactions,
  }) : super(const TransactionState());

  Future<void> onLoadTransactions() async {
    state = state.copyWith(isLoading: true, clearError: true);

    finalEither = await getAllTransactions();

    finalEither.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (transactions) {
        final pending = transactions
            .where((t) => t.status == AppConstants.pendingStatus)
            .toList();

        state = state.copyWith(
          isLoading: false,
          transactions: transactions,
          pendingTransactions: pending,
          offlineCount: pending.length,
        );
      },
    );
  }

  Future<void> onLoadPendingTransactions() async {
    state = state.copyWith(isLoading: true, clearError: true);

    finalEither = await getPendingTransactions();

    finalEither.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (pendingTransactions) {
        state = state.copyWith(
          isLoading: false,
          pendingTransactions: pendingTransactions,
          offlineCount: pendingTransactions.length,
        );
      },
    );
  }

  Future<void> onAddTransaction(AddTransactionEvent event) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final transaction = Transaction(
      id: '',
      recipientId: event.recipientId,
      amount: event.amount,
      description: event.description,
      scheduledDate: event.scheduledDate,
      status: AppConstants.pendingStatus,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final saveResult = await saveTransaction(transaction);

    await saveResult.fold(
      (failure) async {
        String errorMsg = failure.message;
        if (failure is SyncFailure) {
          final offlineLimitFailure = failure;
          errorMsg =
              'No se pueden guardar más transacciones offline. Límite alcanzado: ${AppConstants.maxOfflineTransactions}';
        }
        state = state.copyWith(
          isLoading: false,
          errorMessage: errorMsg,
        );
      },
      (_) async {
        await onLoadTransactions();
      },
    );
  }

  Future<void> onSyncTransactions() async {
    if (!state.isConnected) {
      state = state.copyWith(
        errorMessage: 'No hay conexión a internet para sincronizar',
      );
      return;
    }

    if (state.pendingTransactions.isEmpty) {
      return;
    }

    state = state.copyWith(
      isSyncing: true,
      syncStatus: TransactionSyncStatus.syncing,
      clearError: true,
    );

    final syncResult = await syncTransactions(state.pendingTransactions);

    syncResult.fold(
      (failure) {
        if (failure is SyncFailure) {
          state = state.copyWith(
            isSyncing: false,
            syncStatus: TransactionSyncStatus.failed,
            errorMessage: failure.message,
          );
        } else {
          state = state.copyWith(
            isSyncing: false,
            syncStatus: TransactionSyncStatus.failed,
            errorMessage: failure.message,
          );
        }
      },
      (syncResponse) {
        state = state.copyWith(
          isSyncing: false,
          syncStatus: syncResponse.failedCount > 0
              ? TransactionSyncStatus.partialFailure
              : TransactionSyncStatus.synced,
          syncedCount: syncResponse.syncedCount,
          failedCount: syncResponse.failedCount,
        );
        onLoadTransactions();
      },
    );
  }

  Future<void> onDeleteTransaction(String transactionId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final deleteResult = await Future.value(
      const Right<Failure, bool>(true),
    );

    await deleteResult.fold(
      (failure) async {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (_) async {
        final updatedTransactions = state.transactions
            .where((t) => t.id != transactionId)
            .toList();
        final updatedPending = state.pendingTransactions
            .where((t) => t.id != transactionId)
            .toList();

        state = state.copyWith(
          isLoading: false,
          transactions: updatedTransactions,
          pendingTransactions: updatedPending,
          offlineCount: updatedPending.length,
        );
      },
    );
  }

  Future<void> onRetrySyncSingle(String transactionId) async {
    final pendingTx = state.pendingTransactions
        .where((t) => t.id == transactionId)
        .toList();

    if (pendingTx.isEmpty) {
      return;
    }

    state = state.copyWith(
      isSyncing: true,
      syncStatus: TransactionSyncStatus.syncing,
      clearError: true,
    );

    final syncResult = await syncTransactions(pendingTx);

    syncResult.fold(
      (failure) {
        state = state.copyWith(
          isSyncing: false,
          syncStatus: TransactionSyncStatus.failed,
          errorMessage: failure.message,
        );
      },
      (syncResponse) {
        state = state.copyWith(
          isSyncing: false,
          syncStatus: syncResponse.failedCount > 0
              ? TransactionSyncStatus.partialFailure
              : TransactionSyncStatus.synced,
          syncedCount: syncResponse.syncedCount,
          failedCount: syncResponse.failedCount,
        );
        onLoadTransactions();
      },
    );
  }

  void onConnectivityChanged(bool isConnected) {
    final wasConnected = state.isConnected;
    state = state.copyWith(isConnected: isConnected);

    if (!wasConnected && isConnected && state.hasPendingTransactions) {
      onSyncTransactions();
    }
  }

  void onClearError() {
    state = state.copyWith(clearError: true);
  }
}