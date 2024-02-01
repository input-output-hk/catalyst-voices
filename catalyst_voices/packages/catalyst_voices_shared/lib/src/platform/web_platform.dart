import 'package:catalyst_voices_shared/src/platform/platform_interface.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:web/web.dart';

final class CatalystPlatform extends PlatformInterface {
  static bool get _isMobileOS {
    final userAgent = window.navigator.userAgent.toLowerCase();
    const mobileIdentifiers = [
      'android',
      'ipad',
      'iphone',
    ];
    return mobileIdentifiers.any(userAgent.contains);
  }

  @override
  bool get isAndroid => false;

  @override
  bool get isDesktop => false;

  @override
  bool get isFuchsia => false;

  @override
  bool get isIOS => false;

  @override
  bool get isLinux => false;

  @override
  bool get isMacOS => false;

  @override
  bool get isMobile => false;

  @override
  bool get isMobileWeb => _isMobileOS;

  @override
  bool get isWebDesktop => kIsWeb && !_isMobileOS;

  @override
  bool get isWindows => false;
}
