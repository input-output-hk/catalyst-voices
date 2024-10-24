import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that implementations of catalyst_key_derivation must
/// implement.
///
/// Platform implementations should extend this class rather than implement
/// it as `catalyst_key_derivation` does not consider newly added methods to
/// be breaking changes. Extending this class (using `extends`) ensures that the
/// subclass will get the default implementation, while platform implementations
/// that `implements` this interface will be broken by newly added
/// [CatalystKeyDerivationPlatform] methods.
abstract class CatalystKeyDerivationPlatform extends PlatformInterface {
  static final Object _token = Object();

  static CatalystKeyDerivationPlatform? _instance;

  /// The default instance of [CatalystKeyDerivationPlatform] to use.
  ///
  /// Must be set with [instance] setter before it can be used.
  static CatalystKeyDerivationPlatform get instance {
    assert(
      _instance != null,
      'Make sure to register the instance via '
      'instance setter before it is used.',
    );
    return _instance!;
  }

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [CatalystKeyDerivationPlatform] when they register
  /// themselves.
  static set instance(CatalystKeyDerivationPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Constructs a [CatalystKeyDerivationPlatform].
  CatalystKeyDerivationPlatform() : super(token: _token);
}
