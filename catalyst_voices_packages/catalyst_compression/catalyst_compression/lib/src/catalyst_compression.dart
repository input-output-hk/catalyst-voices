import 'package:catalyst_compression/catalyst_compression.dart';
import 'package:catalyst_compression_platform_interface/catalyst_compression_platform_interface.dart';

/// A Flutter plugin exposing brotli and zstd compression/decompression algorithms.
final class CatalystCompression {
  /// The default instance of [CatalystCompression] to use.
  static final CatalystCompression instance = CatalystCompression._();

  CatalystCompression._();

  /// Returns the brotli compressor.
  CatalystCompressor get brotli {
    return CatalystCompressionPlatform.instance.brotli;
  }

  /// Returns the zstd compressor.
  ///
  /// Compressing more than 100 bytes is recommended,
  /// otherwise the algorithm might provide larger results
  /// than before the compression.
  ///
  /// [CompressionNotSupportedException] is thrown when trying to compress
  /// less than 101 bytes.
  CatalystCompressor get zstd {
    return CatalystCompressionPlatform.instance.zstd;
  }
}
