import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:payment_app/domain/entities/transaction.dart';
import 'package:payment_app/presentation/bloc/transaction_bloc.dart';
import 'package:payment_app/presentation/bloc/transaction_event.dart';
import 'package:payment_app/presentation/bloc/transaction_state.dart';
import 'package:payment_app/presentation/widgets/transaction_item.dart';
import 'package:payment_app/presentation/widgets/sync_status_indicator.dart';
import 'package:payment_app/core/constants/app_constants.dart';
import 'add_transaction_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(transactionBlocProvider.notifier).add(LoadTransactionsEvent());
    });
  }

  Future<void> _onRefresh() async {
    ref.read(transactionBlocProvider.notifier).add(SyncTransactionsEvent());
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _navigateToAddTransaction() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (context) => const AddTransactionScreen(),
      ),
    );
    if (result == true && mounted) {
      ref.read(transactionBlocProvider.notifier).add(LoadTransactionsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactionState = ref.watch(transactionBlocProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        backgroundColor: Color(AppConstants.primaryColor),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(transactionBlocProvider.notifier).add(SyncTransactionsEvent());
            },
            tooltip: 'Sincronizar transacciones',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(AppConstants.primaryColor).withValues(alpha: 0.1),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mis Transacciones',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Color(AppConstants.primaryColor),
                  ),
                ),
                const SizedBox(height: 8),
                const SyncStatusIndicator(),
              ],
            ),
          ),
          Expanded(
            child: _buildTransactionList(transactionState, theme),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddTransaction,
        backgroundColor: Color(AppConstants.primaryColor),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nueva Transacción'),
      ),
    );
  }

  Widget _buildTransactionList(TransactionState state, ThemeData theme) {
    if (state is TransactionLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is TransactionError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Color(AppConstants.errorColor),
              ),
              const SizedBox(height: 16),
              Text(
                state.message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  ref.read(transactionBlocProvider.notifier).add(LoadTransactionsEvent());
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }

    if (state is TransactionLoaded) {
      if (state.transactions.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_outlined,
                  size: 80,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(height: 16),
                Text(
                  'No hay transacciones',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Toca el botón + para crear tu primera transacción',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }

      final pendingCount = state.transactions.where((t) => t.status == AppConstants.pendingStatus).length;
      final syncedCount = state.transactions.where((t) => t.status == AppConstants.syncedStatus).length;
      final failedCount = state.transactions.where((t) => t.status == AppConstants.failedStatus).length;

      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatusChip(
                    'Pendientes',
                    pendingCount,
                    Color(AppConstants.warningColor),
                  ),
                  _buildStatusChip(
                    'Sincronizadas',
                    syncedCount,
                    Color(AppConstants.successColor),
                  ),
                  _buildStatusChip(
                    'Fallidas',
                    failedCount,
                    Color(AppConstants.errorColor),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: state.transactions.length,
                itemBuilder: (context, index) {
                  final transaction = state.transactions[index];
                  return TransactionItem(
                    transaction: transaction,
                    onTap: () => _showTransactionDetails(transaction),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    return const Center(
      child: Text('Cargando transacciones...'),
    );
  }

  Widget _buildStatusChip(String label, int count, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            '$label: $count',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _showTransactionDetails(Transaction transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Detalles de Transacción',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              _buildDetailRow('ID', transaction.id),
              _buildDetailRow('Monto', '\${transaction.amount.toStringAsFixed(2)}'),
              _buildDetailRow('Destinatario', transaction.recipient),
              _buildDetailRow('Estado', _getStatusLabel(transaction.status)),
              _buildDetailRow('Fecha', _formatDate(transaction.createdAt)),
              if (transaction.description != null)
                _buildDetailRow('Descripción', transaction.description!),
              if (transaction.errorMessage != null)
                _buildDetailRow('Error', transaction.errorMessage!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case AppConstants.pendingStatus:
        return 'Pendiente';
      case AppConstants.syncedStatus:
        return 'Sincronizada';
      case AppConstants.failedStatus:
        return 'Fallida';
      default:
        return status;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}