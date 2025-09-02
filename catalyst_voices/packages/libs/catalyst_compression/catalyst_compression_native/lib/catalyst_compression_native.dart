import 'package:catalyst_compression_native/src/catalyst_compression_native_codecs.dart';
import 'package:catalyst_compression_platform_interface/catalyst_compression_platform_interface.dart';

/// The native implementation of [CatalystCompressionPlatform].
///
/// This class implements the `package:catalyst_compression` functionality
/// for the native platforms.
final class CatalystCompressionNative extends CatalystCompressionPlatform {
  /// A constructor that allows tests to override the window object used by the
  /// plugin.
  CatalystCompressionNative();

  @override
  CatalystCompressor get brotli => const RustBrotliCompressor();

  @override
  CatalystCompressor get zstd => const RustZstdCompressor();

  /// Registers this class as the default instance of
  /// [CatalystCompressionPlatform].
  static void registerWith() {
    CatalystCompressionPlatform.instance = CatalystCompressionNative();
  }
}
