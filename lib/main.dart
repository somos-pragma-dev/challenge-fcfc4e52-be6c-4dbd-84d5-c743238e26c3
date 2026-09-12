import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/core/constants/app_constants.dart';
import 'package:payment_app/injection_container.dart' as di;
import 'package:payment_app/presentation/screens/home_screen.dart';
import 'package:payment_app/core/network/network_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const ProviderScope(child: PaymentApp()));
}

class PaymentApp extends ConsumerStatefulWidget {
  const PaymentApp({super.key});

  @override
  ConsumerState<PaymentApp> createState() => _PaymentAppState();
}

class _PaymentAppState extends ConsumerState<PaymentApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeNetworkMonitoring();
  }

  void _initializeNetworkMonitoring() {
    final networkInfo = di.sl<NetworkInfo>();
    networkInfo.onConnectivityChanged.listen((isConnected) {
      if (isConnected) {
        _triggerSyncIfNeeded();
      }
    });
  }

  void _triggerSyncIfNeeded() {
    debugPrint('Network connectivity restored, checking for pending transactions...');
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConstants.primaryColor,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          elevation: 4,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}