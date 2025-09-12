import 'package:catalyst_compression/catalyst_compression.dart';

final class CatalystCompression {
  static CatalystCompressor _brotli = const CatalystBrotliCompressor();

  static CatalystCompressor _zstd = const CatalystZstdCompressor();

  static CatalystCompressor get brotli => _brotli;

  static CatalystCompressor get zstd => _zstd;

  // ignore: use_setters_to_change_properties
  static void overrideBrotli(CatalystCompressor compressor) {
    _brotli = compressor;
  }

  // ignore: use_setters_to_change_properties
  static void overrideZstd(CatalystCompressor compressor) {
    _zstd = compressor;
  }
}
