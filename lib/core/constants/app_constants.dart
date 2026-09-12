class AppConstants {
  AppConstants._();

  static const String appName = 'Payment App';
  static const String appVersion = '1.0.0';
  
  static const int maxOfflineTransactions = 100;
  
  static const int syncBatchSize = 50;
  static const int syncRetryAttempts = 3;
  static const int syncRetryDelayMs = 2000;
  
  static const int cacheExpirationHours = 24;
  static const int maxCacheItems = 1000;
  
  static const String baseUrl = 'https://api.payment-app.example.com';
  static const String apiVersion = 'v1';
  static const int connectionTimeoutMs = 30000;
  static const int receiveTimeoutMs = 30000;
  
  static const int primaryColor = 0xFF6366F1;
  static const int secondaryColor = 0xFF8B5CF6;
  static const int errorColor = 0xFFEF4444;
  static const int successColor = 0xFF22C55E;
  static const int warningColor = 0xFFF59E0B;
  
  static const String transactionTableName = 'transactions';
  static const String syncLogTableName = 'sync_log';
  static const String settingsTableName = 'settings';
  
  static const String pendingStatus = 'pending';
  static const String syncedStatus = 'synced';
  static const String failedStatus = 'failed';
  
  static const String secureStorageKeyLastSync = 'last_sync_timestamp';
  static const String secureStorageKeyUserToken = 'user_auth_token';
  static const String secureStorageKeyUserId = 'user_id';
  
  static const double minTransactionAmount = 0.01;
  static const double maxTransactionAmount = 100000.00;
  
  static const String currencyCode = 'USD';
  static const int decimalPlaces = 2;
}