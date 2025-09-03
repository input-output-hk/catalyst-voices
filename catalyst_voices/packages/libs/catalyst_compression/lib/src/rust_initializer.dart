import 'package:catalyst_compression/src/rust/frb_generated.dart' as rust;

class RustInitializer {
  static Future<void>? _initFuture;

  const RustInitializer._();

  static Future<void> ensureInitialized() async {
    return _initFuture ??= rust.RustLib.init();
  }
}
