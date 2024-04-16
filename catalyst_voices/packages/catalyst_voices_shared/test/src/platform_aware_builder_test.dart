import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildApp() => MaterialApp(
        home: Scaffold(
          body: PlatformAwareBuilder<String>(
            other: 'other',
            builder: (context, platformData) => Text(platformData!),
          ),
        ),
      );

  group('Test platform detection', () {
    testWidgets('PlatformWidgetBuilder fallbacks to other', (tester) async {
      await tester.pumpWidget(buildApp());
      // Verify the Widget renders properly
      expect(find.byType(Text), findsOneWidget);
      // Check the output contains the platform that was tested.
      expect(find.text('other'), findsOneWidget);
    });
  });
}
