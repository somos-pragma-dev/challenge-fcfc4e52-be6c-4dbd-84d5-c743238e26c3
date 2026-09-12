abstract class TransactionRemoteDataSource {
  Future<List<TransactionModel>> fetchTransactions();
  Future<TransactionModel> createTransaction(TransactionModel transaction);
  Future<TransactionModel> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
  Future<bool> checkServerHealth();
  Future<List<TransactionModel>> getAllTransactions();
  Future<TransactionModel> getTransactionById(String id);
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final Dio dio;

  TransactionRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<TransactionModel>> fetchTransactions() async {
    try {
      final response = await dio.get('/transactions');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;
        return data.map((json) => TransactionModel.fromJson(json as Map<String, dynamic>)).toList();
      }
      throw ServerException(
        message: 'Failed to fetch transactions',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<TransactionModel> createTransaction(TransactionModel transaction) async {
    try {
      final response = await dio.post('/transactions', data: transaction.toJson());
      if (response.statusCode == 200 || response.statusCode == 201) {
        return TransactionModel.fromJson(response.data as Map<String, dynamic>);
      }
      throw ServerException(
        message: 'Failed to create transaction',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<TransactionModel> updateTransaction(TransactionModel transaction) async {
    try {
      final response = await dio.put('/transactions/${transaction.id}', data: transaction.toJson());
      if (response.statusCode == 200) {
        return TransactionModel.fromJson(response.data as Map<String, dynamic>);
      }
      throw ServerException(
        message: 'Failed to update transaction',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    try {
      final response = await dio.delete('/transactions/$id');
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(
          message: 'Failed to delete transaction',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  @override
  Future<bool> checkServerHealth() async {
    try {
      final response = await dio.get('/health');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    return fetchTransactions();
  }

  @override
  Future<TransactionModel> getTransactionById(String id) async {
    try {
      final response = await dio.get('/transactions/$id');
      if (response.statusCode == 200) {
        return TransactionModel.fromJson(response.data as Map<String, dynamic>);
      }
      throw ServerException(
        message: 'Transaction not found',
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  ServerException _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ServerException(
          message: 'Connection timeout',
          statusCode: 408,
        );
      case DioExceptionType.badResponse:
        return ServerException(
          message: e.response?.statusMessage ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.connectionError:
        return ServerException(
          message: 'No internet connection',
          statusCode: null,
        );
      default:
        return ServerException(
          message: e.message ?? 'Unknown error',
          statusCode: null,
        );
    }
  }
}