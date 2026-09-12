import 'package:flutter/material.dart';
import 'package:payment_app/core/constants/app_constants.dart';
import 'package:payment_app/domain/entities/transaction.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;

  const TransactionItem({
    super.key,
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = _getStatusColor();
    final statusIcon = _getStatusIcon();
    final statusLabel = _getStatusLabel();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  statusIcon,
                  color: statusColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.recipient,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          _formatDate(transaction.createdAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                        if (transaction.description != null && transaction.description!.isNotEmpty) ...
                          [
                            const SizedBox(width: 8),
                            Icon(
                              Icons.notes,
                              size: 14,
                              color: Colors.grey[400],
                            ),
                          ],
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\${transaction.amount.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Color(AppConstants.primaryColor),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (transaction.status) {
      case AppConstants.pendingStatus:
        return Color(AppConstants.warningColor);
      case AppConstants.syncedStatus:
        return Color(AppConstants.successColor);
      case AppConstants.failedStatus:
        return Color(AppConstants.errorColor);
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon() {
    switch (transaction.status) {
      case AppConstants.pendingStatus:
        return Icons.schedule;
      case AppConstants.syncedStatus:
        return Icons.check_circle;
      case AppConstants.failedStatus:
        return Icons.error;
      default:
        return Icons.help_outline;
    }
  }

  String _getStatusLabel() {
    switch (transaction.status) {
      case AppConstants.pendingStatus:
        return 'Pendiente';
      case AppConstants.syncedStatus:
        return 'Sincronizada';
      case AppConstants.failedStatus:
        return 'Fallida';
      default:
        return transaction.status;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Hace un momento';
        }
        return 'Hace ${difference.inMinutes} min';
      }
      return 'Hace ${difference.inHours} h';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../core/network/network_info.dart';
import '../../core/constants/app_constants.dart';

enum SyncStatus { synced, pending, failed, offline }

class SyncStatusIndicator extends ConsumerStatefulWidget {
  final VoidCallback? onSyncPressed;
  final bool showLabel;
  final double iconSize;

  const SyncStatusIndicator({
    super.key,
    this.onSyncPressed,
    this.showLabel = true,
    this.iconSize = 24.0,
  });

  @override
  ConsumerState<SyncStatusIndicator> createState() => _SyncStatusIndicatorState();
}

class _SyncStatusIndicatorState extends ConsumerState<SyncStatusIndicator> {
  SyncStatus _currentStatus = SyncStatus.offline;
  bool _isSyncing = false;
  int _pendingCount = 0;

  @override
  void initState() {
    super.initState();
    _initializeStatus();
  }

  void _initializeStatus() async {
    final networkInfo = ref.read(networkInfoProvider);
    final isConnected = await networkInfo.isConnected;
    
    if (!isConnected) {
      setState(() => _currentStatus = SyncStatus.offline);
    }
    
    _listenToConnectivityChanges();
  }

  void _listenToConnectivityChanges() {
    final networkInfo = ref.read(networkInfoProvider);
    networkInfo.onConnectivityChanged.listen((isConnected) {
      if (mounted) {
        setState(() {
          if (!isConnected) {
            _currentStatus = SyncStatus.offline;
          } else if (_pendingCount > 0) {
            _currentStatus = SyncStatus.pending;
          } else {
            _currentStatus = SyncStatus.synced;
          }
        });
      }
    });
  }

  void _updatePendingCount(int count) {
    if (mounted) {
      setState(() {
        _pendingCount = count;
        if (_currentStatus != SyncStatus.offline) {
          _currentStatus = count > 0 ? SyncStatus.pending : SyncStatus.synced;
        }
      });
    }
  }

  Future<void> _handleSync() async {
    if (_isSyncing || _currentStatus == SyncStatus.offline) return;
    
    setState(() => _isSyncing = true);
    
    try {
      widget.onSyncPressed?.call();
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (mounted) {
        setState(() {
          _isSyncing = false;
          _pendingCount = 0;
          _currentStatus = SyncStatus.synced;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSyncing = false;
          _currentStatus = SyncStatus.failed;
        });
      }
    }
  }

  Color _getStatusColor() {
    switch (_currentStatus) {
      case SyncStatus.synced:
        return Color(AppConstants.successColor);
      case SyncStatus.pending:
        return Color(AppConstants.warningColor);
      case SyncStatus.failed:
        return Color(AppConstants.errorColor);
      case SyncStatus.offline:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon() {
    switch (_currentStatus) {
      case SyncStatus.synced:
        return Icons.cloud_done;
      case SyncStatus.pending:
        return Icons.cloud_upload;
      case SyncStatus.failed:
        return Icons.cloud_off;
      case SyncStatus.offline:
        return Icons.cloud_outlined;
    }
  }

  String _getStatusLabel() {
    switch (_currentStatus) {
      case SyncStatus.synced:
        return 'Sincronizado';
      case SyncStatus.pending:
        return '$_pendingCount pendiente${_pendingCount != 1 ? 's' : ''}';
      case SyncStatus.failed:
        return 'Error de sincronización';
      case SyncStatus.offline:
        return 'Sin conexión';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleSync,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _getStatusColor().withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _getStatusColor().withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isSyncing)
              SizedBox(
                width: widget.iconSize,
                height: widget.iconSize,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(_getStatusColor()),
                ),
              )
            else
              Icon(
                _getStatusIcon(),
                size: widget.iconSize,
                color: _getStatusColor(),
              ),
            if (widget.showLabel) ...[
              const SizedBox(width: 8),
              Text(
                _getStatusLabel(),
                style: TextStyle(
                  color: _getStatusColor(),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl(Connectivity());
});

final syncStatusProvider = StateNotifierProvider<SyncStatusNotifier, SyncStatusState>((ref) {
  final networkInfo = ref.watch(networkInfoProvider);
  return SyncStatusNotifier(networkInfo);
});

class SyncStatusState {
  final SyncStatus status;
  final int pendingCount;
  final bool isSyncing;
  final DateTime? lastSyncTime;

  const SyncStatusState({
    this.status = SyncStatus.offline,
    this.pendingCount = 0,
    this.isSyncing = false,
    this.lastSyncTime,
  });

  SyncStatusState copyWith({
    SyncStatus? status,
    int? pendingCount,
    bool? isSyncing,
    DateTime? lastSyncTime,
  }) {
    return SyncStatusState(
      status: status ?? this.status,
      pendingCount: pendingCount ?? this.pendingCount,
      isSyncing: isSyncing ?? this.isSyncing,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }
}

class SyncStatusNotifier extends StateNotifier<SyncStatusState> {
  final NetworkInfo _networkInfo;

  SyncStatusNotifier(this._networkInfo) : super(const SyncStatusState()) {
    _init();
  }

  void _init() async {
    final isConnected = await _networkInfo.isConnected;
    state = state.copyWith(
      status: isConnected ? SyncStatus.synced : SyncStatus.offline,
    );
    
    _networkInfo.onConnectivityChanged.listen((isConnected) {
      if (isConnected && state.pendingCount > 0) {
        state = state.copyWith(status: SyncStatus.pending);
      } else if (isConnected) {
        state = state.copyWith(status: SyncStatus.synced);
      } else {
        state = state.copyWith(status: SyncStatus.offline);
      }
    });
  }

  void updatePendingCount(int count) {
    state = state.copyWith(
      pendingCount: count,
      status: count > 0 ? SyncStatus.pending : SyncStatus.synced,
    );
  }

  void setSyncing(bool syncing) {
    state = state.copyWith(isSyncing: syncing);
  }

  void syncComplete() {
    state = state.copyWith(
      status: SyncStatus.synced,
      pendingCount: 0,
      isSyncing: false,
      lastSyncTime: DateTime.now(),
    );
  }

  void syncFailed() {
    state = state.copyWith(
      status: SyncStatus.failed,
      isSyncing: false,
    );
  }
}