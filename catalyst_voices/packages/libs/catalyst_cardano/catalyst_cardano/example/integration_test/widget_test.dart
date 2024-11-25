import 'package:catalyst_cardano_example/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  binding.framePolicy = LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  group('Cardano example', () {
    testWidgets('Check if supported extensions are displayed', (tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 5));

      expect(find.byType(ElevatedButton), findsAny);
    });

    testWidgets('Click button show wallet extension window', (tester) async {
      await tester.pumpWidget(const MyApp());

      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 5));

      final buttonFinder = find.byType(ElevatedButton);
      await tester.tap(buttonFinder);
      await tester.pump();

      // Use evaluateJavaScript directly

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
