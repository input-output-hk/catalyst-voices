import 'package:catalyst_cardano_example/main.dart' as app;
import 'package:flutter_driver/driver_extension.dart';

Future<void> main() async {
  enableFlutterDriverExtension();
  await app.main();
}