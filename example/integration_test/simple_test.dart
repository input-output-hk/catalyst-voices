import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:catalyst_voices_workspace/catalyst_voices_workspace.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async => await RustLib.init());
  test('Can call rust function', () async {
    expect(greet(name: "Tom"), "Hello, Tom!");
  });
}
