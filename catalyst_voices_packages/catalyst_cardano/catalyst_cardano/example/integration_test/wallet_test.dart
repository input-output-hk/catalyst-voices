import 'package:catalyst_cardano_example/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  group('Connect wallet', () {
    IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    testWidgets('Enable wallet', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      final Finder enableWalletButton =
          find.widgetWithText(ElevatedButton, 'Enable wallet');

      await tester.tap(enableWalletButton);

      await tester.pumpAndSettle();
    });
  });
}
