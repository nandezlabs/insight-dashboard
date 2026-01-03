import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:insight_core/insight_core.dart';

/// Sync state
class SyncState {
  final SyncStatus status;
  final DateTime? lastSyncTime;
  final bool isAutoSyncEnabled;
  final List<SyncConflict> conflicts;

  const SyncState({
    required this.status,
    this.lastSyncTime,
    this.isAutoSyncEnabled = false,
    this.conflicts = const [],
  });

  SyncState copyWith({
    SyncStatus? status,
    DateTime? lastSyncTime,
    bool? isAutoSyncEnabled,
    List<SyncConflict>? conflicts,
  }) {
    return SyncState(
      status: status ?? this.status,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      isAutoSyncEnabled: isAutoSyncEnabled ?? this.isAutoSyncEnabled,
      conflicts: conflicts ?? this.conflicts,
    );
  }
}

/// Sync notifier
class SyncNotifier extends StateNotifier<SyncState> {
  final SyncService _syncService;

  SyncNotifier(this._syncService)
      : super(SyncState(status: SyncStatus.idle()));

  /// Initialize sync service
  Future<void> initialize() async {
    await _syncService.initialize();
  }

  /// Start automatic sync
  void startAutoSync() {
    _syncService.startAutoSync();
    state = state.copyWith(isAutoSyncEnabled: true);
  }

  /// Stop automatic sync
  void stopAutoSync() {
    _syncService.stopAutoSync();
    state = state.copyWith(isAutoSyncEnabled: false);
  }

  /// Manually trigger sync
  Future<void> sync() async {
    state = state.copyWith(status: SyncStatus.syncing());
    
    final result = await _syncService.performSync();
    
    state = state.copyWith(
      status: result,
      lastSyncTime: DateTime.now(),
      conflicts: result.maybeMap(
        error: (e) => e.conflicts,
        orElse: () => [],
      ),
    );
  }

  /// Resolve a conflict by choosing client or server data
  Future<void> resolveConflict(SyncConflict conflict, bool useServerData) async {
    // TODO: Implement conflict resolution
    final updatedConflicts = state.conflicts.where((c) => c != conflict).toList();
    state = state.copyWith(conflicts: updatedConflicts);
  }

  @override
  void dispose() {
    _syncService.stopAutoSync();
    super.dispose();
  }
}

/// Sync service provider
final syncServiceProvider = Provider<SyncService>((ref) {
  // TODO: Get database from proper provider
  throw UnimplementedError('Database provider not yet implemented');
});

/// Sync state provider
final syncProvider = StateNotifierProvider<SyncNotifier, SyncState>((ref) {
  final syncService = ref.watch(syncServiceProvider);
  return SyncNotifier(syncService);
});
