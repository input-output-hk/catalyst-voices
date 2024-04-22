import 'dart:async';

import 'package:catalyst_cardano_platform_interface/catalyst_cardano_platform_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart' show Registrar;

/// The web implementation of [CatalystCardanoPlatform].
///
/// This class implements the `package:catalyst_cardano` functionality
/// for the web.
class CatalystCardanoPlugin extends CatalystCardanoPlatform {
  /// A constructor that allows tests to override the window object used by the
  /// plugin.
  CatalystCardanoPlugin();

  @override
  Future<void> printHello() async {
    // ignore: avoid_print
    print('hello world from cardano multiplatform');
  }

  /// Registers this class as the default instance of
  /// [CatalystCardanoPlatform].
  static void registerWith(Registrar registrar) {
    CatalystCardanoPlatform.instance = CatalystCardanoPlugin();
  }
}
