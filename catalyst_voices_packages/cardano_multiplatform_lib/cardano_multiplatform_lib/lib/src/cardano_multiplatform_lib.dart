import 'package:cardano_multiplatform_lib_platform_interface/cardano_multiplatform_lib_platform_interface.dart';

/// Prints hello message, function to be removed later by providing actual
/// implementations of methods related to cardano multiplatform lib.
Future<void> printCardanoMultiplatformHello() async {
  // ignore: avoid_print, will be replaced later by actual implementation
  await CardanoMultiplatformLibPlatform.instance.printHello();
}
