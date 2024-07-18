import 'package:catalyst_compression_platform_interface/src/catalyst_compressor.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// The interface that implementations of catalyst_compression must
/// implement.
///
/// Platform implementations should extend this class rather than implement
/// it as `catalyst_compression` does not consider newly added methods to
/// be breaking changes. Extending this class (using `extends`) ensures that the
/// subclass will get the default implementation, while platform implementations
/// that `implements` this interface will be broken by newly added
/// [CatalystCompressionPlatform] methods.
abstract class CatalystCompressionPlatform extends PlatformInterface {
  static final Object _token = Object();

  static CatalystCompressionPlatform? _instance;

  /// The default instance of [CatalystCompressionPlatform] to use.
  ///
  /// Must be set with [instance] setter before it can be used.
  static CatalystCompressionPlatform get instance {
    assert(
      _instance != null,
      'Make sure to register the instance via '
      'instance setter before it is used.',
    );
    return _instance!;
  }

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [CatalystCompressionPlatform] when they register
  /// themselves.
  static set instance(CatalystCompressionPlatform instance) {
    PlatformInterface.verify(instance, _token);
    _instance = instance;
  }

  /// Constructs a [CatalystCompressionPlatform].
  CatalystCompressionPlatform() : super(token: _token);

  /// Returns the brotli compressor.
  CatalystCompressor get brotli {
    throw UnimplementedError('brotli has not been implemented.');
  }

  /// Returns the zstd compressor.
  CatalystCompressor get zstd {
    throw UnimplementedError('zstd has not been implemented.');
  }
}
