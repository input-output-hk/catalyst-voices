@JS('catalyst_compression')
library catalyst_compression_interop;

import 'dart:js_interop';

import 'package:catalyst_compression_platform_interface/catalyst_compression_platform_interface.dart';
import 'package:convert/convert.dart';

/// Compresses the [bytes] using brotli algorithm.
///
/// The bytes are transferred as hex string due to
/// raw bytes not being supported by the js_interop.
@JS()
external JSString brotliCompress(JSString bytes);

/// Decompresses the [bytes] using brotli algorithm.
///
/// The bytes are transferred as hex string due to
/// raw bytes not being supported by the js_interop.
@JS()
external JSString brotliDecompress(JSString bytes);

/// Compresses the [bytes] using zstd algorithm.
///
/// The bytes are transferred as hex string due to
/// raw bytes not being supported by the js_interop.
@JS()
external JSString zstdCompress(JSString bytes);

/// Decompresses the [bytes] using zstd algorithm.
///
/// The bytes are transferred as hex string due to
/// raw bytes not being supported by the js_interop.
@JS()
external JSString zstdDecompress(JSString bytes);

/// The JS implementation of brotli compressor.
class JSBrotliCompressor implements CatalystCompressor {
  /// The default constructor for [JSBrotliCompressor].
  const JSBrotliCompressor();

  @override
  List<int> compress(List<int> bytes) {
    final data = brotliCompress(hex.encode(bytes).toJS).toDart;
    return hex.decode(data);
  }

  @override
  List<int> decompress(List<int> bytes) {
    final data = brotliDecompress(hex.encode(bytes).toJS).toDart;
    return hex.decode(data);
  }
}

/// The JS implementation of zstd compressor.
class JSZstdCompressor implements CatalystCompressor {
  /// The default constructor for [JSZstdCompressor].
  const JSZstdCompressor();

  @override
  List<int> compress(List<int> bytes) {
    final data = zstdCompress(hex.encode(bytes).toJS).toDart;
    return hex.decode(data);
  }

  @override
  List<int> decompress(List<int> bytes) {
    final data = zstdDecompress(hex.encode(bytes).toJS).toDart;
    return hex.decode(data);
  }
}
