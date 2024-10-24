import 'package:catalyst_voices/app/view/app.dart';
import 'package:catalyst_voices/configs/bootstrap.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End to end tests', () {
    testWidgets('run app', (tester) async {
      final args = await bootstrap();
      await tester.pumpWidget(App(routerConfig: args.routerConfig));
      // let the application load
      await tester.pump(const Duration(seconds: 5));
      // pump and settle every 100ms to simulate almost production-like FPS
      await tester.pumpAndSettle(const Duration(milliseconds: 100));
      //expect(find.text('Coming'), findsOneWidget);
    });
  });
}
