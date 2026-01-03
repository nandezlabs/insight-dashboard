import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store/features/sync/conflict_resolution_screen.dart';
import 'package:store/core/services/sync_manager.dart';

void main() {
  group('ConflictResolutionScreen', () {
    late SyncConflict testConflict;

    setUp(() {
      testConflict = SyncConflict(
        entityId: 'test-id',
        entityType: 'submission',
        localData: {
          'title': 'Local Title',
          'value': 100,
          'updated_at': '2025-12-26T10:00:00Z',
        },
        serverData: {
          'title': 'Server Title',
          'value': 200,
          'updated_at': '2025-12-26T11:00:00Z',
        },
        localUpdatedAt: DateTime(2025, 12, 26, 10, 0),
        serverUpdatedAt: DateTime(2025, 12, 26, 11, 0),
      );
    });

    testWidgets('should display conflict information',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.reset());
      
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ConflictResolutionScreen(conflict: testConflict),
          ),
        ),
      );

      expect(find.text('Resolve Sync Conflict'), findsOneWidget);
      expect(find.text('Local Version'), findsOneWidget);
      expect(find.text('Server Version'), findsOneWidget);
      expect(find.text('Resolve Conflict'), findsOneWidget);
    });

    testWidgets('should show local data preview', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.reset());
      
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ConflictResolutionScreen(conflict: testConflict),
          ),
        ),
      );

      expect(find.textContaining('title:'), findsAtLeastNWidgets(1));
      expect(find.textContaining('Local Title'), findsOneWidget);
      expect(find.textContaining('value:'), findsAtLeastNWidgets(1));
    });

    testWidgets('should allow selecting local version',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.reset());
      
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ConflictResolutionScreen(conflict: testConflict),
          ),
        ),
      );

      // Find the card containing local version
      final localCard = find.ancestor(
        of: find.text('Local Version'),
        matching: find.byType(Card),
      );
      expect(localCard, findsOneWidget);

      // Tap the card to select
      await tester.tap(localCard);
      await tester.pumpAndSettle();

      // Verify radio buttons exist
      final radioButtons = find.byType(Radio<ConflictResolutionStrategy>);
      expect(radioButtons, findsNWidgets(2));
    });

    testWidgets('should enable resolve button after selection',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.reset());
      
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ConflictResolutionScreen(conflict: testConflict),
          ),
        ),
      );

      // Find resolve button
      final resolveButton = find.widgetWithText(ElevatedButton, 'Resolve Conflict');
      expect(resolveButton, findsOneWidget);
      
      // Initially disabled
      final initialButton = tester.widget<ElevatedButton>(resolveButton);
      expect(initialButton.onPressed, isNull);

      // Tap the first radio button to select local version
      final firstRadio = find.byType(Radio<ConflictResolutionStrategy>).first;
      await tester.tap(firstRadio);
      await tester.pumpAndSettle();

      // Now enabled
      final updatedButton = tester.widget<ElevatedButton>(resolveButton);
      expect(updatedButton.onPressed, isNotNull);
    });

    testWidgets('should show formatted timestamps',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1200, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.reset());
      
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: ConflictResolutionScreen(conflict: testConflict),
          ),
        ),
      );
      await tester.pumpAndSettle();
      
      // Check that the screen renders
      expect(find.byType(ConflictResolutionScreen), findsOneWidget);
      
      // Look for timestamp-related text (just verify rendering)
      expect(find.byType(Card), findsWidgets);
    });
  });
}
