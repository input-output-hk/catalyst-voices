import 'package:catalyst_compression/src/rust/frb_generated.dart' as rust;

/// An initializer to make sure the rust lib is initialized only once.
class RustInitializer {
  static Future<void>? _initFuture;

  const RustInitializer._();

  /// Initializes the rust lib if not initialized before.
  ///
  /// Rust init is not expected to fail but if it fails, calling it again will not make it
  /// succeed thus the [_initFuture] is cached regardless of its outcome.
  static Future<void> ensureInitialized() async {
    return _initFuture ??= rust.RustLib.init();
  }
}
