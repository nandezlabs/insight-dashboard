import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/services/sync_manager.dart';

/// Widget that shows online/offline status
class ConnectivityIndicator extends ConsumerWidget {
  const ConnectivityIndicator({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isOnline ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOnline ? Icons.cloud_done : Icons.cloud_off,
            size: 16,
            color: Colors.white,
          ),
          const SizedBox(width: 4),
          Text(
            isOnline ? 'Online' : 'Offline',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget that shows pending sync count
class SyncStatusBadge extends ConsumerWidget {
  const SyncStatusBadge({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingCountAsync = ref.watch(pendingSyncCountProvider);
    
    return pendingCountAsync.when(
      data: (count) {
        if (count == 0) return const SizedBox.shrink();
        
        return Badge(
          label: Text(count.toString()),
          backgroundColor: Colors.orange,
          child: const Icon(Icons.sync),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

/// Widget that shows sync status and allows manual sync
class SyncStatusWidget extends ConsumerWidget {
  const SyncStatusWidget({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);
    final syncStatusAsync = ref.watch(syncStatusProvider);
    final pendingCountAsync = ref.watch(pendingSyncCountProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Sync Status',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                const ConnectivityIndicator(),
              ],
            ),
            const SizedBox(height: 16),
            syncStatusAsync.when(
              data: (status) => _buildSyncStatus(context, status),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('Error loading sync status'),
            ),
            const SizedBox(height: 12),
            pendingCountAsync.when(
              data: (count) => Text(
                count == 0
                    ? 'All changes synced'
                    : '$count ${count == 1 ? 'change' : 'changes'} pending sync',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            if (isOnline) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _syncNow(ref, context),
                  icon: const Icon(Icons.sync),
                  label: const Text('Sync Now'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildSyncStatus(BuildContext context, SyncStatus status) {
    IconData icon;
    Color color;
    String text;
    
    switch (status) {
      case SyncStatus.synced:
        icon = Icons.check_circle;
        color = Colors.green;
        text = 'Synced';
        break;
      case SyncStatus.pending:
        icon = Icons.pending;
        color = Colors.orange;
        text = 'Pending';
        break;
      case SyncStatus.syncing:
        icon = Icons.sync;
        color = Colors.blue;
        text = 'Syncing...';
        break;
      case SyncStatus.error:
        icon = Icons.error;
        color = Colors.red;
        text = 'Error';
        break;
    }
    
    return Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 8),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
  
  Future<void> _syncNow(WidgetRef ref, BuildContext context) async {
    try {
      final syncManager = ref.read(syncManagerProvider);
      await syncManager.forceSyncNow();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sync completed successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sync failed: $e')),
        );
      }
    }
  }
}

/// Floating sync indicator that shows in the corner
class FloatingSyncIndicator extends ConsumerWidget {
  const FloatingSyncIndicator({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncStatusAsync = ref.watch(syncStatusProvider);
    
    return syncStatusAsync.when(
      data: (status) {
        if (status != SyncStatus.syncing) {
          return const SizedBox.shrink();
        }
        
        return Positioned(
          bottom: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Syncing...',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

/// Banner that shows when offline
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnline = ref.watch(isOnlineProvider);
    
    if (isOnline) return const SizedBox.shrink();
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.orange,
      child: Row(
        children: [
          const Icon(Icons.cloud_off, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'You are offline. Changes will sync when connection is restored.',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
