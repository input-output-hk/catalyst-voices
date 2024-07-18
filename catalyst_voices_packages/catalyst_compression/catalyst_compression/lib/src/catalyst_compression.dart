import 'package:catalyst_compression/catalyst_compression.dart';
import 'package:catalyst_compression_platform_interface/catalyst_compression_platform_interface.dart';

/// A Flutter plugin exposing brotli and zstd compression/decompression algorithms.
class CatalystCompression {
  /// The default instance of [CatalystCompression] to use.
  static final CatalystCompression instance = CatalystCompression._();

  CatalystCompression._();

  /// Returns the brotli compressor.
  CatalystCompressor get brotli {
    return CatalystCompressionPlatform.instance.brotli;
  }

  /// Returns the zstd compressor.
  CatalystCompressor get zstd {
    return CatalystCompressionPlatform.instance.zstd;
  }
}
