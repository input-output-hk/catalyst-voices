import 'package:catalyst_key_derivation_platform_interface/catalyst_key_derivation_platform_interface.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart' show Registrar;

/// The web implementation of [CatalystKeyDerivationPlatform].
///
/// This class implements the `package:catalyst_key_derivation` functionality
/// for the web.
final class CatalystKeyDerivationWeb extends CatalystKeyDerivationPlatform {
  /// A constructor that allows tests to override the window object used by the
  /// plugin.
  CatalystKeyDerivationWeb();

  /// Registers this class as the default instance of
  /// [CatalystKeyDerivationPlatform].
  static void registerWith(Registrar registrar) {
    CatalystKeyDerivationPlatform.instance = CatalystKeyDerivationWeb();
  }
}
