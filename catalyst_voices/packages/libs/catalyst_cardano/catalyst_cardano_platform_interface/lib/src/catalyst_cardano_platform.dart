import 'dart:async';

import 'package:catalyst_cardano_platform_interface/src/cardano_wallet.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that implementations of catalyst_cardano must
/// implement.
///
/// Platform implementations should extend this class rather than implement
/// it as `catalyst_cardano` does not consider newly added methods to
/// be breaking changes. Extending this class (using `extends`) ensures that the
/// subclass will get the default implementation, while platform implementations
/// that `implements` this interface will be broken by newly added
/// [CatalystCardanoPlatform] methods.
abstract class CatalystCardanoPlatform extends PlatformInterface {
  static final Object _token = Object();

  static CatalystCardanoPlatform? _instance;

  /// The default instance of [CatalystCardanoPlatform] to use.
  ///
  /// Must be set with [instance] setter before it can be used.
  static CatalystCardanoPlatform get instance {
    assert(
      _instance != null,
      'Make sure to register the instance via '
      'instance setter before it is used.',
    );
    return _instance!;
  }

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [CatalystCardanoPlatform] when they register
  /// themselves.
  static set instance(CatalystCardanoPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Constructs a CatalystCardanoPlatform.
  CatalystCardanoPlatform() : super(token: _token);

  /// Returns available wallet extensions exposed under
  /// cardano.{walletName} according to CIP-30 standard.
  Future<List<CardanoWallet>> getWallets() {
    throw UnimplementedError('getWallets() has not been implemented.');
  }
}
