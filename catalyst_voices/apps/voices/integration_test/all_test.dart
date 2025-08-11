import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    binding.testTextInput.register();
  });

  tearDownAll(() {
    binding.testTextInput.unregister();
  });

  group('Account Tests', () {
    testWidgets('description', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('app')),
            backgroundColor: Colors.blue,
          ),
        ),
      );

      expect(find.text('app'), findsOneWidget);
    });
  });
}
