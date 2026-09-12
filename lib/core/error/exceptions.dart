class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({required this.message, this.statusCode});

  @override
  String toString() => 'ServerException: $message (code: $statusCode)';
}

class CacheException implements Exception {
  final String message;
  final String? operation;

  const CacheException({required this.message, this.operation});

  @override
  String toString() => 'CacheException: $message (operation: $operation)';
}

class NetworkException implements Exception {
  final String message;
  final int? code;

  const NetworkException({required this.message, this.code});

  @override
  String toString() => 'NetworkException: $message (code: $code)';
}

class SyncException implements Exception {
  final String message;
  final String? transactionId;
  final bool isRetryable;

  const SyncException({
    required this.message,
    this.transactionId,
    this.isRetryable = false,
  });

  @override
  String toString() => 'SyncException: $message (transactionId: $transactionId, retryable: $isRetryable)';
}

class DatabaseException implements Exception {
  final String message;
  final String? query;
  final dynamic originalError;

  const DatabaseException({
    required this.message,
    this.query,
    this.originalError,
  });

  @override
  String toString() => 'DatabaseException: $message (query: $query, error: $originalError)';
}

class OfflineLimitException implements Exception {
  final int currentCount;
  final int maxAllowed;

  const OfflineLimitException({
    required this.currentCount,
    required this.maxAllowed,
  });

  @override
  String toString() => 'OfflineLimitException: Cannot store more than $maxAllowed transactions offline. Current: $currentCount';
}

class ValidationException implements Exception {
  final String message;
  final Map<String, String>? fieldErrors;

  const ValidationException({required this.message, this.fieldErrors});

  @override
  String toString() => 'ValidationException: $message (fieldErrors: $fieldErrors)';
}