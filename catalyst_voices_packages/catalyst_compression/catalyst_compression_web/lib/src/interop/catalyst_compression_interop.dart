@JS('catalyst_compression')
library catalyst_compression_interop;

import 'dart:js_interop';
import 'dart:js_util';

import 'package:catalyst_compression_platform_interface/catalyst_compression_platform_interface.dart';
import 'package:convert/convert.dart';

/// Compresses the [bytes] using brotli algorithm.
///
/// The bytes are transferred as hex string due to
/// raw bytes not being supported by the js_interop.
@JS()
external JSPromise<JSString> brotliCompress(JSString bytes);

/// Decompresses the [bytes] using brotli algorithm.
///
/// The bytes are transferred as hex string due to
/// raw bytes not being supported by the js_interop.
@JS()
external JSPromise<JSString> brotliDecompress(JSString bytes);

/// Compresses the [bytes] using zstd algorithm.
///
/// The bytes are transferred as hex string due to
/// raw bytes not being supported by the js_interop.
@JS()
external JSPromise<JSString> zstdCompress(JSString bytes);

/// Decompresses the [bytes] using zstd algorithm.
///
/// The bytes are transferred as hex string due to
/// raw bytes not being supported by the js_interop.
@JS()
external JSPromise<JSString> zstdDecompress(JSString bytes);

/// The JS implementation of brotli compressor.
class JSBrotliCompressor implements CatalystCompressor {
  /// The default constructor for [JSBrotliCompressor].
  const JSBrotliCompressor();

  @override
  Future<List<int>> compress(List<int> bytes) async {
    final data =
        await promiseToFuture<JSString>(brotliCompress(hex.encode(bytes).toJS));
    return hex.decode(data.toDart);
  }

  @override
  Future<List<int>> decompress(List<int> bytes) async {
    final data =
        await promiseToFuture<JSString>(brotliDecompress(hex.encode(bytes).toJS));
    return hex.decode(data.toDart);
  }
}

/// The JS implementation of zstd compressor.
class JSZstdCompressor implements CatalystCompressor {
  /// The minimum length of bytes for which the compression
  /// algorithm works correctly.
  ///
  /// Trying to compress bytes fewer than this might yield bigger
  /// results than before the compression.
  static const int _minLength = 101;

  /// The default constructor for [JSZstdCompressor].
  const JSZstdCompressor();

  @override
  Future<List<int>> compress(List<int> bytes) async {
    if (bytes.length < _minLength) {
      throw CompressionNotSupportedException(
        'Bytes too short, actual: ${bytes.length}, required: $_minLength',
      );
    }

    final data =
        await promiseToFuture<JSString>(zstdCompress(hex.encode(bytes).toJS));
    return hex.decode(data.toDart);
  }

  @override
  Future<List<int>> decompress(List<int> bytes) async {
    final data =
        await promiseToFuture<JSString>(zstdDecompress(hex.encode(bytes).toJS));
    return hex.decode(data.toDart);
  }
}
