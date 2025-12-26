import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:insight_ui/insight_ui.dart';
import '../../core/providers/app_providers.dart';

class GeofenceCheckScreen extends ConsumerStatefulWidget {
  const GeofenceCheckScreen({super.key});

  @override
  ConsumerState<GeofenceCheckScreen> createState() => _GeofenceCheckScreenState();
}

class _GeofenceCheckScreenState extends ConsumerState<GeofenceCheckScreen> {
  @override
  void initState() {
    super.initState();
    // Check geofence status after widget builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkGeofence();
    });
  }

  Future<void> _checkGeofence() async {
    // Wait a moment for loading effect
    await Future.delayed(const Duration(seconds: 1));
    
    final geofenceStatus = await ref.read(geofenceStatusProvider.future);
    
    if (mounted) {
      if (geofenceStatus) {
        // Location valid, navigate to dashboard
        context.go('/dashboard');
      } else {
        // Show error dialog but allow bypass for testing
        _showLocationError();
      }
    }
  }

  void _showLocationError() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.location_off, color: Colors.red),
            SizedBox(width: 8),
            Text('Location Required'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('You must be at the store to access this app.'),
            SizedBox(height: 16),
            Text(
              'Test mode: Geofencing is currently disabled',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _checkGeofence();
            },
            child: const Text('Retry'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Bypass for testing
              context.go('/dashboard');
            },
            child: const Text('Continue (Test)'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline,
              size: 80,
              color: AppColors.primary,
            ),
            const SizedBox(height: 24),
            Text(
              'Insight',
              style: AppTextStyles.headlineLarge.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Verifying location...',
              style: AppTextStyles.bodyMedium,
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              '(Test mode: Bypass enabled)',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
