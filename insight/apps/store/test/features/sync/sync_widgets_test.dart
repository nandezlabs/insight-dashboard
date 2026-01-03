import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:store/features/sync/sync_widgets.dart';
import 'package:store/core/services/connectivity_service.dart';
import 'package:store/core/services/sync_manager.dart';

void main() {
  group('ConnectivityIndicator', () {
    testWidgets('should show online status when connected',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isOnlineProvider.overrideWith((ref) => true),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: ConnectivityIndicator(),
            ),
          ),
        ),
      );

      expect(find.text('Online'), findsOneWidget);
      expect(find.byIcon(Icons.cloud_done), findsOneWidget);
    });

    testWidgets('should show offline status when disconnected',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isOnlineProvider.overrideWith((ref) => false),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: ConnectivityIndicator(),
            ),
          ),
        ),
      );

      expect(find.text('Offline'), findsOneWidget);
      expect(find.byIcon(Icons.cloud_off), findsOneWidget);
    });
  });

  group('OfflineBanner', () {
    testWidgets('should hide when online', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isOnlineProvider.overrideWith((ref) => true),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: OfflineBanner(),
            ),
          ),
        ),
      );

      expect(find.byType(OfflineBanner), findsOneWidget);
      expect(find.byIcon(Icons.cloud_off), findsNothing);
    });

    testWidgets('should show when offline', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isOnlineProvider.overrideWith((ref) => false),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: OfflineBanner(),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.cloud_off), findsOneWidget);
      expect(
        find.text(
            'You are offline. Changes will sync when connection is restored.'),
        findsOneWidget,
      );
    });
  });

  group('SyncStatusBadge', () {
    testWidgets('should hide when no pending items',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            pendingSyncCountProvider.overrideWith((ref) => Stream.value(0)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SyncStatusBadge(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(Badge), findsNothing);
    });

    testWidgets('should show count when items pending',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            pendingSyncCountProvider.overrideWith((ref) => Stream.value(5)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SyncStatusBadge(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('5'), findsOneWidget);
      expect(find.byIcon(Icons.sync), findsOneWidget);
    });
  });

  group('SyncStatusWidget', () {
    testWidgets('should display sync status', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isOnlineProvider.overrideWith((ref) => true),
            syncStatusProvider
                .overrideWith((ref) => Stream.value(SyncStatus.synced)),
            pendingSyncCountProvider.overrideWith((ref) => Stream.value(0)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SyncStatusWidget(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Sync Status'), findsOneWidget);
      expect(find.text('All changes synced'), findsOneWidget);
      expect(find.text('Sync Now'), findsOneWidget);
    });

    testWidgets('should show pending count', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            isOnlineProvider.overrideWith((ref) => true),
            syncStatusProvider
                .overrideWith((ref) => Stream.value(SyncStatus.pending)),
            pendingSyncCountProvider.overrideWith((ref) => Stream.value(3)),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: SyncStatusWidget(),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('3 changes pending sync'), findsOneWidget);
    });
  });
}
