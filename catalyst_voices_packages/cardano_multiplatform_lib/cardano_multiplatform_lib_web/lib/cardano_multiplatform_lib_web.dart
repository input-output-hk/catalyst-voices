import 'dart:async';

import 'package:cardano_multiplatform_lib_platform_interface/cardano_multiplatform_lib_platform_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart' show Registrar;

/// The web implementation of [CardanoMultiplatformLibPlatform].
///
/// This class implements the `package:cardano_multiplatform_lib` functionality
/// for the web.
class CardanoMultiplatformLibPlugin extends CardanoMultiplatformLibPlatform {
  /// A constructor that allows tests to override the window object used by the
  /// plugin.
  CardanoMultiplatformLibPlugin();

  @override
  Future<void> printHello() async {
    // ignore: avoid_print
    print('hello world from cardano multiplatform');
  }

  /// Registers this class as the default instance of
  /// [CardanoMultiplatformLibPlatform].
  static void registerWith(Registrar registrar) {
    CardanoMultiplatformLibPlatform.instance = CardanoMultiplatformLibPlugin();
  }
}
