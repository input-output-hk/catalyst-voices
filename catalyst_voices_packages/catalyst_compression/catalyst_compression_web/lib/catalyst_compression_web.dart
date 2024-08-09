import 'package:catalyst_compression_platform_interface/catalyst_compression_platform_interface.dart';
import 'package:catalyst_compression_web/src/interop/catalyst_compression_interop.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart' show Registrar;

/// The web implementation of [CatalystCompressionPlatform].
///
/// This class implements the `package:catalyst_compression` functionality
/// for the web.
final class CatalystCompressionWeb extends CatalystCompressionPlatform {
  /// A constructor that allows tests to override the window object used by the
  /// plugin.
  CatalystCompressionWeb();

  /// Registers this class as the default instance of
  /// [CatalystCompressionPlatform].
  static void registerWith(Registrar registrar) {
    CatalystCompressionPlatform.instance = CatalystCompressionWeb();
  }

  @override
  CatalystCompressor get brotli => const JSBrotliCompressor();

  @override
  CatalystCompressor get zstd => const JSZstdCompressor();
}
