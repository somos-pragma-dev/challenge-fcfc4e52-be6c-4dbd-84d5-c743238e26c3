package payment_app.domain.entities;

import 'package:equatable/equatable.dart';

enum TransactionStatus {
  pending,
  synced,
  failed,
}

class Transaction extends Equatable {
  final String id;
  final double amount;
  final String recipient;
  final String recipientAccount;
  final String description;
  final TransactionStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? syncedAt;
  final int retryCount;
  final String? failureReason;

  const Transaction({
    required this.id,
    required this.amount,
    required this.recipient,
    required this.recipientAccount,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.syncedAt,
    this.retryCount = 0,
    this.failureReason,
  });

  bool get isPending => status == TransactionStatus.pending;
  bool get isSynced => status == TransactionStatus.synced;
  bool get isFailed => status == TransactionStatus.failed;
  bool get canRetry => isFailed && retryCount < 3;

  Transaction copyWith({
    String? id,
    double? amount,
    String? recipient,
    String? recipientAccount,
    String? description,
    TransactionStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? syncedAt,
    int? retryCount,
    String? failureReason,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      recipient: recipient ?? this.recipient,
      recipientAccount: recipientAccount ?? this.recipientAccount,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      retryCount: retryCount ?? this.retryCount,
      failureReason: failureReason ?? this.failureReason,
    );
  }

  factory Transaction.create({
    required String id,
    required double amount,
    required String recipient,
    required String recipientAccount,
    String? description,
  }) {
    final now = DateTime.now();
    return Transaction(
      id: id,
      amount: amount,
      recipient: recipient,
      recipientAccount: recipientAccount,
      description: description ?? '',
      status: TransactionStatus.pending,
      createdAt: now,
      updatedAt: now,
      retryCount: 0,
    );
  }

  Transaction markAsSynced() {
    return copyWith(
      status: TransactionStatus.synced,
      syncedAt: DateTime.now(),
      updatedAt: DateTime.now(),
      failureReason: null,
    );
  }

  Transaction markAsFailed(String reason) {
    return copyWith(
      status: TransactionStatus.failed,
      updatedAt: DateTime.now(),
      failureReason: reason,
      retryCount: retryCount + 1,
    );
  }

  @override
  List<Object?> get props => [
        id,
        amount,
        recipient,
        recipientAccount,
        description,
        status,
        createdAt,
        updatedAt,
        syncedAt,
        retryCount,
        failureReason,
      ];
}