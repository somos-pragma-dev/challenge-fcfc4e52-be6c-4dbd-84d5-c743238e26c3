part of 'transaction_bloc.dart';

enum TransactionSyncStatus {
  idle,
  syncing,
  synced,
  failed,
  partialFailure,
}

class TransactionState extends Equatable {
  final List<Transaction> transactions;
  final List<Transaction> pendingTransactions;
  final bool isLoading;
  final bool isSyncing;
  final bool isConnected;
  final String? errorMessage;
  final TransactionSyncStatus syncStatus;
  final int syncedCount;
  final int failedCount;
  final int offlineCount;

  const TransactionState({
    this.transactions = const [],
    this.pendingTransactions = const [],
    this.isLoading = false,
    this.isSyncing = false,
    this.isConnected = true,
    this.errorMessage,
    this.syncStatus = TransactionSyncStatus.idle,
    this.syncedCount = 0,
    this.failedCount = 0,
    this.offlineCount = 0,
  });

  TransactionState copyWith({
    List<Transaction>? transactions,
    List<Transaction>? pendingTransactions,
    bool? isLoading,
    bool? isSyncing,
    bool? isConnected,
    String? errorMessage,
    TransactionSyncStatus? syncStatus,
    int? syncedCount,
    int? failedCount,
    int? offlineCount,
    bool clearError = false,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      pendingTransactions: pendingTransactions ?? this.pendingTransactions,
      isLoading: isLoading ?? this.isLoading,
      isSyncing: isSyncing ?? this.isSyncing,
      isConnected: isConnected ?? this.isConnected,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      syncStatus: syncStatus ?? this.syncStatus,
      syncedCount: syncedCount ?? this.syncedCount,
      failedCount: failedCount ?? this.failedCount,
      offlineCount: offlineCount ?? this.offlineCount,
    );
  }

  bool get hasPendingTransactions => pendingTransactions.isNotEmpty;
  bool get canSync => isConnected && hasPendingTransactions;
  bool get hasError => errorMessage != null;

  double get totalPendingAmount {
    return pendingTransactions.fold(0.0, (sum, t) => sum + t.amount);
  }

  double get totalSyncedAmount {
    return transactions
        .where((t) => t.status == AppConstants.syncedStatus)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  @override
  List<Object?> get props => [
        transactions,
        pendingTransactions,
        isLoading,
        isSyncing,
        isConnected,
        errorMessage,
        syncStatus,
        syncedCount,
        failedCount,
        offlineCount,
      ];
}