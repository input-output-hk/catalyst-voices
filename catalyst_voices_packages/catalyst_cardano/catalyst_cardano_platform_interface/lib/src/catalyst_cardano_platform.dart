import 'dart:async';
import 'dart:typed_data';

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

  /// Temporary method which will be replaced by actual implementation of
  /// cardano multiplatform lib.
  Future<void> encodeArbitraryBytesAsMetadatum(Uint8List bytes) {
    throw UnimplementedError(
      'encodeArbitraryBytesAsMetadatum() has not been implemented.',
    );
  }

  /// Initializer method to bootstrap internals of Cardano Multiplatform Lib.
  ///
  /// Must be called and awaited exactly once before any
  /// additional interaction with the lib.
  Future<void> init() {
    throw UnimplementedError('initialize() has not been implemented.');
  }
}
