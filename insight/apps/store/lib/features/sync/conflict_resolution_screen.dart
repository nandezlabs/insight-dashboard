import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/sync_manager.dart';

/// Screen for resolving sync conflicts
class ConflictResolutionScreen extends ConsumerStatefulWidget {
  final SyncConflict conflict;
  
  const ConflictResolutionScreen({
    super.key,
    required this.conflict,
  });
  
  @override
  ConsumerState<ConflictResolutionScreen> createState() =>
      _ConflictResolutionScreenState();
}

class _ConflictResolutionScreenState
    extends ConsumerState<ConflictResolutionScreen> {
  ConflictResolutionStrategy? _selectedStrategy;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resolve Sync Conflict'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sync Conflict Detected',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Text(
              'The ${widget.conflict.entityType} has been modified both locally and on the server.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            _buildVersionCard(
              context,
              title: 'Local Version',
              data: widget.conflict.localData,
              timestamp: widget.conflict.localUpdatedAt,
              strategy: ConflictResolutionStrategy.useLocal,
            ),
            const SizedBox(height: 16),
            _buildVersionCard(
              context,
              title: 'Server Version',
              data: widget.conflict.serverData,
              timestamp: widget.conflict.serverUpdatedAt,
              strategy: ConflictResolutionStrategy.useServer,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedStrategy == null
                    ? null
                    : () => _resolveConflict(),
                child: const Text('Resolve Conflict'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildVersionCard(
    BuildContext context, {
    required String title,
    required Map<String, dynamic> data,
    required DateTime timestamp,
    required ConflictResolutionStrategy strategy,
  }) {
    final isSelected = _selectedStrategy == strategy;
    
    return Card(
      color: isSelected
          ? Theme.of(context).colorScheme.primaryContainer
          : null,
      child: InkWell(
        onTap: () => setState(() => _selectedStrategy = strategy),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Radio<ConflictResolutionStrategy>(
                    value: strategy,
                    groupValue: _selectedStrategy,
                    onChanged: (value) =>
                        setState(() => _selectedStrategy = value),
                  ),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  Icon(
                    isSelected ? Icons.check_circle : Icons.circle_outlined,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Last modified: ${_formatDateTime(timestamp)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              _buildDataPreview(context, data),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildDataPreview(BuildContext context, Map<String, dynamic> data) {
    // Show a preview of the data differences
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: data.entries.take(5).map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${entry.key}: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Expanded(
                  child: Text(
                    entry.value.toString(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
  
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }
  
  Future<void> _resolveConflict() async {
    if (_selectedStrategy == null) return;
    
    try {
      final syncManager = ref.read(syncManagerProvider);
      await syncManager.resolveConflict(
        widget.conflict,
        _selectedStrategy!,
      );
      
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Conflict resolved successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to resolve conflict: $e')),
        );
      }
    }
  }
}
