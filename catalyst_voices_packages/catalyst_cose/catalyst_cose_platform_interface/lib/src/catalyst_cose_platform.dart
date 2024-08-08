import 'package:cbor/cbor.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that implementations of catalyst_cose must
/// implement.
///
/// Platform implementations should extend this class rather than implement
/// it as `catalyst_cose` does not consider newly added methods to
/// be breaking changes. Extending this class (using `extends`) ensures that the
/// subclass will get the default implementation, while platform implementations
/// that `implements` this interface will be broken by newly added
/// [CatalystCosePlatform] methods.
abstract class CatalystCosePlatform extends PlatformInterface {
  static final Object _token = Object();

  static CatalystCosePlatform? _instance;

  /// The default instance of [CatalystCosePlatform] to use.
  ///
  /// Must be set with [instance] setter before it can be used.
  static CatalystCosePlatform get instance {
    assert(
      _instance != null,
      'Make sure to register the instance via '
      'instance setter before it is used.',
    );
    return _instance!;
  }

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [CatalystCosePlatform] when they register
  /// themselves.
  static set instance(CatalystCosePlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Constructs a [CatalystCosePlatform].
  CatalystCosePlatform() : super(token: _token);

  /// Signs the [message] and returns a [CborValue] representing
  /// a COSE signature.
  Future<CborValue> signMessage(List<int> message) {
    throw UnimplementedError('signMessage has not been implemented.');
  }
}
