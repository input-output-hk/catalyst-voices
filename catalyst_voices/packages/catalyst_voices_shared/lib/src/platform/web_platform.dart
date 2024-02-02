import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:web/web.dart';

final class CatalystPlatform {
  static bool get isAndroid => false;

  static bool get isDesktop => false;

  static bool get isFuchsia => false;

  static bool get isIOS => false;

  static bool get isLinux => false;

  static bool get isMacOS => false;

  static bool get isMobile => false;

  static bool get isMobileWeb => _isMobileOS;

  static bool get isWeb => kIsWeb;

  static bool get isWebDesktop => kIsWeb && !_isMobileOS;

  static bool get isWindows => false;

  static bool get _isMobileOS {
    final userAgent = window.navigator.userAgent.toLowerCase();
    const mobileIdentifiers = [
      'android',
      'ipad',
      'iphone',
    ];
    return mobileIdentifiers.any(userAgent.contains);
  }

  const CatalystPlatform._();
}
