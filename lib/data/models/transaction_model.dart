import 'package:equatable/equatable.dart';
import '../../domain/entities/transaction.dart';

class TransactionModel extends Equatable {
  final String id;
  final double amount;
  final String recipientId;
  final String recipientName;
  final String? description;
  final DateTime createdAt;
  final DateTime? syncedAt;
  final String status;
  final String? failureReason;
  final int retryCount;

  const TransactionModel({
    required this.id,
    required this.amount,
    required this.recipientId,
    required this.recipientName,
    this.description,
    required this.createdAt,
    this.syncedAt,
    required this.status,
    this.failureReason,
    this.retryCount = 0,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      recipientId: json['recipient_id'] as String,
      recipientName: json['recipient_name'] as String,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      syncedAt: json['synced_at'] != null
          ? DateTime.parse(json['synced_at'] as String)
          : null,
      status: json['status'] as String,
      failureReason: json['failure_reason'] as String?,
      retryCount: json['retry_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'recipient_id': recipientId,
      'recipient_name': recipientName,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'synced_at': syncedAt?.toIso8601String(),
      'status': status,
      'failure_reason': failureReason,
      'retry_count': retryCount,
    };
  }

  factory TransactionModel.fromEntity(Transaction entity) {
    return TransactionModel(
      id: entity.id,
      amount: entity.amount,
      recipientId: entity.recipientId,
      recipientName: entity.recipientName,
      description: entity.description,
      createdAt: entity.createdAt,
      syncedAt: entity.syncedAt,
      status: entity.status,
      failureReason: entity.failureReason,
      retryCount: entity.retryCount,
    );
  }

  Transaction toEntity() {
    return Transaction(
      id: id,
      amount: amount,
      recipientId: recipientId,
      recipientName: recipientName,
      description: description,
      createdAt: createdAt,
      syncedAt: syncedAt,
      status: status,
      failureReason: failureReason,
      retryCount: retryCount,
    );
  }

  TransactionModel copyWith({
    String? id,
    double? amount,
    String? recipientId,
    String? recipientName,
    String? description,
    DateTime? createdAt,
    DateTime? syncedAt,
    String? status,
    String? failureReason,
    int? retryCount,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      recipientId: recipientId ?? this.recipientId,
      recipientName: recipientName ?? this.recipientName,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      syncedAt: syncedAt ?? this.syncedAt,
      status: status ?? this.status,
      failureReason: failureReason ?? this.failureReason,
      retryCount: retryCount ?? this.retryCount,
    );
  }

  @override
  List<Object?> get props => [
        id,
        amount,
        recipientId,
        recipientName,
        description,
        createdAt,
        syncedAt,
        status,
        failureReason,
        retryCount,
      ];
}