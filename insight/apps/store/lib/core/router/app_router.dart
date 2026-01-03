import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:insight_core/insight_core.dart';
import '../../features/geofence/geofence_check_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/forms/forms_list_screen.dart';
import '../../features/form_viewer/form_viewer_screen.dart';

final goRouter = GoRouter(
  initialLocation: '/geofence-check',
  routes: [
    GoRoute(
      path: '/geofence-check',
      name: 'geofence-check',
      builder: (context, state) => const GeofenceCheckScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      name: 'dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/forms',
      name: 'forms',
      builder: (context, state) => const FormsListScreen(),
    ),
    GoRoute(
      path: '/form/:formId',
      name: 'form-viewer',
      builder: (context, state) {
        final formId = state.pathParameters['formId']!;
        final form = state.extra as FormModel?;
        
        return FormViewerScreen(
          formId: formId,
          form: form,
        );
      },
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Page not found: ${state.uri}'),
    ),
  ),
);
