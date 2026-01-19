library catalyst_browser;

export 'package:catalyst_voices_shared/src/browser/browser_stub.dart'
    if (dart.library.io) 'io_browser.dart'
    if (dart.library.js_interop) 'web_browser.dart';
