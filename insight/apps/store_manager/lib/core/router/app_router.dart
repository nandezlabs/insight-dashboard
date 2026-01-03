import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:insight_core/insight_core.dart';
import '../../features/overview/overview_screen.dart';
import '../../features/forms/forms_library_screen.dart';
import '../../features/forms/form_builder_screen.dart';
import '../../features/analytics/analytics_screen.dart';
import '../../features/goals/goals_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/auth/login_screen.dart';
import '../providers/auth_provider.dart';
import 'app_shell.dart';

// Router provider for access to Riverpod
final goRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/overview',
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isLoginRoute = state.uri.path == '/login';

      // Redirect to login if not authenticated and not on login route
      if (!isAuthenticated && !isLoginRoute) {
        return '/login';
      }

      // Redirect to overview if authenticated and on login route
      if (isAuthenticated && isLoginRoute) {
        return '/overview';
      }

      return null;
    },
    routes: [
      // Auth routes (no shell)
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),

      // Protected routes (with shell)
      ShellRoute(
        builder: (context, state, child) {
          return AppShell(
            currentRoute: state.uri.path,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/overview',
            name: 'overview',
            builder: (context, state) => const OverviewScreen(),
          ),
          GoRoute(
            path: '/forms',
            name: 'forms',
            builder: (context, state) => const FormsLibraryScreen(),
          ),
          GoRoute(
            path: '/analytics',
            name: 'analytics',
            builder: (context, state) => const AnalyticsScreen(),
          ),
          GoRoute(
            path: '/goals',
            name: 'goals',
            builder: (context, state) => const GoalsScreen(),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/forms/create',
        name: 'form-create',
        builder: (context, state) => const FormBuilderScreen(),
      ),
      GoRoute(
        path: '/forms/:formId/edit',
        name: 'form-edit',
        builder: (context, state) {
          final formId = state.pathParameters['formId']!;
          final form = state.extra as FormModel?;

          return FormBuilderScreen(
            formId: formId,
            existingForm: form,
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
});

// Keep old router for backward compatibility during transition
final goRouter = goRouterProvider;
