import 'dart:async';
import 'dart:js_interop';

import 'package:catalyst_cardano_platform_interface/catalyst_cardano_platform_interface.dart';
import 'package:catalyst_cardano_web/src/interop/catalyst_cardano_interop.dart'
    as interop;
import 'package:flutter_web_plugins/flutter_web_plugins.dart' show Registrar;

/// The web implementation of [CatalystCardanoPlatform].
///
/// This class implements the `package:catalyst_cardano` functionality
/// for the web.
final class CatalystCardanoWeb extends CatalystCardanoPlatform {
  /// A constructor that allows tests to override the window object used by the
  /// plugin.
  CatalystCardanoWeb();

  @override
  Future<List<CardanoWallet>> getWallets() async {
    final wallets = interop.getWallets().toDart;
    return wallets.map((e) => e.toDart).toList();
  }

  /// Registers this class as the default instance of
  /// [CatalystCardanoPlatform].
  static void registerWith(Registrar registrar) {
    CatalystCardanoPlatform.instance = CatalystCardanoWeb();
  }
}
