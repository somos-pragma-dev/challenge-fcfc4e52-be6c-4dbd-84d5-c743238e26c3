part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransactionsEvent extends TransactionEvent {
  const LoadTransactionsEvent();
}

class LoadPendingTransactionsEvent extends TransactionEvent {
  const LoadPendingTransactionsEvent();
}

class AddTransactionEvent extends TransactionEvent {
  final String recipientId;
  final double amount;
  final String description;
  final DateTime scheduledDate;

  const AddTransactionEvent({
    required this.recipientId,
    required this.amount,
    required this.description,
    required this.scheduledDate,
  });

  @override
  List<Object?> get props => [recipientId, amount, description, scheduledDate];
}

class SyncTransactionsEvent extends TransactionEvent {
  const SyncTransactionsEvent();
}

class DeleteTransactionEvent extends TransactionEvent {
  final String transactionId;

  const DeleteTransactionEvent({required this.transactionId});

  @override
  List<Object?> get props => [transactionId];
}

class RetrySyncSingleEvent extends TransactionEvent {
  final String transactionId;

  const RetrySyncSingleEvent({required this.transactionId});

  @override
  List<Object?> get props => [transactionId];
}

class RefreshConnectivityEvent extends TransactionEvent {
  final bool isConnected;

  const RefreshConnectivityEvent({required this.isConnected});

  @override
  List<Object?> get props => [isConnected];
}

class ClearErrorEvent extends TransactionEvent {
  const ClearErrorEvent();
}