library catalyst_platform;

export 'stub_platform.dart'
    if (dart.library.io) 'io_platform.dart'
    if (dart.library.html) 'web_platform.dart';
