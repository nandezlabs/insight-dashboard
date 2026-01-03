import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insight_core/insight_core.dart';
import 'package:insight_ui/insight_ui.dart';
import 'package:intl/intl.dart';
import '../../core/providers/sync_provider.dart';

/// Sync status indicator widget
class SyncStatusIndicator extends ConsumerWidget {
  const SyncStatusIndicator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncProvider);
    
    return syncState.status.map(
      idle: (_) => IconButton(
        icon: const Icon(Icons.sync),
        tooltip: 'Sync',
        onPressed: () => ref.read(syncProvider.notifier).sync(),
      ),
      syncing: (_) => const Padding(
        padding: EdgeInsets.all(12.0),
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      success: (_) => IconButton(
        icon: const Icon(Icons.cloud_done, color: AppColors.success),
        tooltip: syncState.lastSyncTime != null
            ? 'Last synced: ${_formatTime(syncState.lastSyncTime!)}'
            : 'Synced',
        onPressed: () => _showSyncDialog(context, ref),
      ),
      error: (e) => IconButton(
        icon: const Icon(Icons.sync_problem, color: AppColors.error),
        tooltip: 'Sync error',
        onPressed: () => _showSyncDialog(context, ref),
      ),
      alreadySyncing: (_) => const Padding(
        padding: EdgeInsets.all(12.0),
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return DateFormat('MMM d, h:mm a').format(time);
  }

  void _showSyncDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const SyncDialog(),
    );
  }
}

/// Sync dialog with detailed status and controls
class SyncDialog extends ConsumerWidget {
  const SyncDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncProvider);
    
    return AlertDialog(
      title: const Text('Sync Status'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status
            _buildStatusRow(syncState),
            
            if (syncState.lastSyncTime != null) ...[
              const SizedBox(height: 16),
              Text(
                'Last synced: ${DateFormat('MMM d, yyyy h:mm a').format(syncState.lastSyncTime!)}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            
            const SizedBox(height: 24),
            
            // Auto-sync toggle
            SwitchListTile(
              value: syncState.isAutoSyncEnabled,
              onChanged: (enabled) {
                if (enabled) {
                  ref.read(syncProvider.notifier).startAutoSync();
                } else {
                  ref.read(syncProvider.notifier).stopAutoSync();
                }
              },
              title: const Text('Auto-sync'),
              subtitle: const Text('Sync automatically every 5 minutes'),
              contentPadding: EdgeInsets.zero,
            ),
            
            // Conflicts
            if (syncState.conflicts.isNotEmpty) ...[
              const SizedBox(height: 24),
              Text(
                'Conflicts (${syncState.conflicts.length})',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...syncState.conflicts.map((conflict) => 
                _buildConflictCard(context, ref, conflict),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
        FilledButton.icon(
          onPressed: () {
            ref.read(syncProvider.notifier).sync();
          },
          icon: const Icon(Icons.sync),
          label: const Text('Sync Now'),
        ),
      ],
    );
  }

  Widget _buildStatusRow(SyncState syncState) {
    return syncState.status.map(
      idle: (_) => const Row(
        children: [
          Icon(Icons.cloud_off, color: AppColors.textSecondary),
          SizedBox(width: 12),
          Text('Ready to sync'),
        ],
      ),
      syncing: (_) => const Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Text('Syncing...'),
        ],
      ),
      success: (_) => const Row(
        children: [
          Icon(Icons.cloud_done, color: AppColors.success),
          SizedBox(width: 12),
          Text('Synced successfully'),
        ],
      ),
      error: (e) => Row(
        children: [
          const Icon(Icons.error_outline, color: AppColors.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              e.conflicts.isNotEmpty
                  ? 'Sync completed with ${e.conflicts.length} conflict(s)'
                  : 'Sync failed',
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
      alreadySyncing: (_) => const Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Text('Sync in progress...'),
        ],
      ),
    );
  }

  Widget _buildConflictCard(BuildContext context, WidgetRef ref, SyncConflict conflict) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${conflict.table}: ${conflict.recordId}',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (conflict.error != null) ...[
              const SizedBox(height: 4),
              Text(
                conflict.error!,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.error,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ref.read(syncProvider.notifier).resolveConflict(conflict, false);
                    },
                    child: const Text('Use Local'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      ref.read(syncProvider.notifier).resolveConflict(conflict, true);
                    },
                    child: const Text('Use Server'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
