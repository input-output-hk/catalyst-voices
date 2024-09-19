import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:catalyst_voices/app/app.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('tap on the floating action button, verify counter',
        (tester) async {
      final args = await bootstrapTest();
      // Load app widget.
      await tester.pumpWidget(App(routerConfig: args.routerConfig));
      await Future<void>.delayed(Duration(seconds: 5));
    });
  });
}
