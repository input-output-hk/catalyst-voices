import 'dart:async';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that implementations of cardano_multiplatform_lib must
/// implement.
///
/// Platform implementations should extend this class rather than implement
/// it as `cardano_multiplatform_lib` does not consider newly added methods to
/// be breaking changes. Extending this class (using `extends`) ensures that the
/// subclass will get the default implementation, while platform implementations
/// that `implements` this interface will be broken by newly added
/// [CardanoMultiplatformLibPlatform] methods.
abstract class CardanoMultiplatformLibPlatform extends PlatformInterface {
  static final Object _token = Object();

  static CardanoMultiplatformLibPlatform? _instance;

  /// The default instance of [CardanoMultiplatformLibPlatform] to use.
  ///
  /// Must be set with [instance] setter before it can be used.
  static CardanoMultiplatformLibPlatform get instance {
    assert(
      _instance != null,
      'Make sure to register the instance via '
      'instance setter before it is used.',
    );
    return _instance!;
  }

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [CardanoMultiplatformLibPlatform] when they register
  /// themselves.
  static set instance(CardanoMultiplatformLibPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Constructs a CardanoMultiplatformLibPlatform.
  CardanoMultiplatformLibPlatform() : super(token: _token);

  /// Temporary method which will be replaced by actual implementation of
  /// cardano multiplatform lib.
  Future<void> printHello() {
    throw UnimplementedError('printHello() has not been implemented.');
  }
}
