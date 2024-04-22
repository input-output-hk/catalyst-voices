import 'package:catalyst_cardano_platform_interface/catalyst_cardano_platform_interface.dart';

/// Prints hello message, function to be removed later by providing actual
/// implementations of methods related to cardano multiplatform lib.
Future<void> printCatalystCardanoHello() async {
  // ignore: avoid_print, will be replaced later by actual implementation
  await CatalystCardanoPlatform.instance.printHello();
}
