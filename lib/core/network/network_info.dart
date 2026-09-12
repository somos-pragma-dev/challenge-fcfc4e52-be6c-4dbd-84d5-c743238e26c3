import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:payment_app/core/error/exceptions.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;
  final StreamController<bool> _connectivityStreamController = StreamController<bool>.broadcast();
  bool _lastKnownState = true;

  NetworkInfoImpl({required this.connectivity}) {
    _initConnectivityListener();
  }

  void _initConnectivityListener() {
    connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final isConnected = _checkConnection(results);
      if (isConnected != _lastKnownState) {
        _lastKnownState = isConnected;
        _connectivityStreamController.add(isConnected);
      }
    });
  }

  bool _checkConnection(List<ConnectivityResult> results) {
    if (results.isEmpty || results.contains(ConnectivityResult.none)) {
      return false;
    }
    return results.any((result) =>
        result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.ethernet ||
        result == ConnectivityResult.vpn);
  }

  @override
  Future<bool> get isConnected async {
    try {
      final results = await connectivity.checkConnectivity();
      return _checkConnection(results);
    } catch (e) {
      throw NetworkException(
        message: 'Failed to check connectivity: ${e.toString()}',
        code: -1,
      );
    }
  }

  @override
  Stream<bool> get onConnectivityChanged => _connectivityStreamController.stream;

  Future<void> checkAndNotify() async {
    final isConnectedNow = await isConnected;
    if (isConnectedNow != _lastKnownState) {
      _lastKnownState = isConnectedNow;
      _connectivityStreamController.add(isConnectedNow);
    }
  }

  void dispose() {
    _connectivityStreamController.close();
  }
}