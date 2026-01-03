import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service for monitoring network connectivity
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  
  StreamController<bool>? _connectionStatusController;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  
  bool _isOnline = true;
  
  /// Current connectivity status
  bool get isOnline => _isOnline;
  
  /// Stream of connectivity status changes
  Stream<bool> get connectionStatus {
    _connectionStatusController ??= StreamController<bool>.broadcast();
    return _connectionStatusController!.stream;
  }
  
  /// Initialize connectivity monitoring
  Future<void> initialize() async {
    // Check initial connectivity status
    final result = await _connectivity.checkConnectivity();
    _isOnline = _isConnected(result);
    
    // Listen for connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (List<ConnectivityResult> results) {
        final wasOnline = _isOnline;
        _isOnline = _isConnected(results);
        
        // Notify listeners only if status changed
        if (wasOnline != _isOnline) {
          _connectionStatusController?.add(_isOnline);
        }
      },
    );
  }
  
  bool _isConnected(List<ConnectivityResult> results) {
    return results.isNotEmpty && 
           !results.contains(ConnectivityResult.none);
  }
  
  /// Dispose of resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectionStatusController?.close();
  }
}

/// Provider for connectivity service
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  final service = ConnectivityService();
  service.initialize();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Provider for current connectivity status
final connectivityStatusProvider = StreamProvider<bool>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.connectionStatus;
});

/// Provider for checking if device is online
final isOnlineProvider = Provider<bool>((ref) {
  final asyncValue = ref.watch(connectivityStatusProvider);
  return asyncValue.when(
    data: (isOnline) => isOnline,
    loading: () => ref.read(connectivityServiceProvider).isOnline,
    error: (_, __) => false,
  );
});
