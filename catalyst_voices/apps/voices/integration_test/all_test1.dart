import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Minimal Test', (WidgetTester tester) async {
    expect(1, 1); // A basic assertion
  });
}
