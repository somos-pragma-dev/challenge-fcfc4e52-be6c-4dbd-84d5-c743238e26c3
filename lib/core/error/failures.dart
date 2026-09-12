import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});

  factory ServerFailure.fromStatusCode(int statusCode) {
    String message;
    switch (statusCode) {
      case 400:
        message = 'Bad request: The server could not understand the request';
        break;
      case 401:
        message = 'Unauthorized: Authentication is required';
        break;
      case 403:
        message = 'Forbidden: You do not have permission to access this resource';
        break;
      case 404:
        message = 'Not found: The requested resource does not exist';
        break;
      case 500:
        message = 'Internal server error: Something went wrong on the server';
        break;
      case 503:
        message = 'Service unavailable: The server is temporarily unable to handle the request';
        break;
      default:
        message = 'Server error occurred with status code: $statusCode';
    }
    return ServerFailure(message: message, code: statusCode);
  }
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code});

  factory CacheFailure.notFound() {
    return const CacheFailure(
      message: 'Cache miss: The requested data was not found in local storage',
      code: 404,
    );
  }

  factory CacheFailure.writeError() {
    return const CacheFailure(
      message: 'Cache write error: Failed to save data to local storage',
      code: 500,
    );
  }

  factory CacheFailure.readError() {
    return const CacheFailure(
      message: 'Cache read error: Failed to read data from local storage',
      code: 500,
    );
  }
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.code});

  factory NetworkFailure.noConnection() {
    return const NetworkFailure(
      message: 'No internet connection: Please check your network settings',
      code: -1,
    );
  }

  factory NetworkFailure.timeout() {
    return const NetworkFailure(
      message: 'Connection timeout: The server took too long to respond',
      code: -2,
    );
  }

  factory NetworkFailure.unknown([String? details]) {
    return NetworkFailure(
      message: details ?? 'Unknown network error occurred',
      code: -3,
    );
  }
}

class SyncFailure extends Failure {
  const SyncFailure({required super.message, super.code});

  factory SyncFailure.offlineLimitReached(int currentCount) {
    return SyncFailure(
      message: 'Offline limit reached: Cannot store more than ${AppConstants.maxOfflineTransactions} transactions. Current count: $currentCount. Please sync to continue.',
      code: 507,
    );
  }

  factory SyncFailure.conflict(String transactionId) {
    return SyncFailure(
      message: 'Sync conflict: Transaction $transactionId already exists on server',
      code: 409,
    );
  }

  factory SyncFailure.partialFailure(int syncedCount, int failedCount) {
    return SyncFailure(
      message: 'Partial sync failure: $syncedCount synced, $failedCount failed',
      code: 207,
    );
  }
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code});

  factory ValidationFailure.invalidAmount() {
    return const ValidationFailure(
      message: 'Invalid amount: Amount must be greater than zero',
      code: 400,
    );
  }

  factory ValidationFailure.invalidRecipient() {
    return const ValidationFailure(
      message: 'Invalid recipient: Recipient identifier is required',
      code: 400,
    );
  }

  factory ValidationFailure.missingFields(List<String> fields) {
    return ValidationFailure(
      message: 'Missing required fields: ${fields.join(", ")}',
      code: 400,
    );
  }
}