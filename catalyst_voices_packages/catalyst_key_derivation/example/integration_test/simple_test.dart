import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async => RustLib.init());
  test('Can call rust function', () async {
    expect(greet(name: 'Tom'), 'Hello, Tom!');
  });
}
