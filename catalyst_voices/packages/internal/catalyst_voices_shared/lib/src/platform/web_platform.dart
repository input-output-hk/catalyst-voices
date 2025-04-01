import 'package:catalyst_voices_shared/src/platform/platform_key.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:web/web.dart';

final class CatalystPlatform {
  static Map<PlatformKey, bool> get identifiers => {
        PlatformKey.android: isAndroid,
        PlatformKey.desktop: isDesktop,
        PlatformKey.fuchsia: isFuchsia,
        PlatformKey.iOS: isIOS,
        PlatformKey.linux: isLinux,
        PlatformKey.macOS: isMacOS,
        PlatformKey.mobile: isMobile,
        PlatformKey.mobileWeb: isMobileWeb,
        PlatformKey.web: isWeb,
        PlatformKey.webDesktop: isWebDesktop,
        PlatformKey.windows: isWindows,
      };

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
      'ipod',
      'mobile',
      'webos',
    ];
    if (mobileIdentifiers.any(userAgent.contains)) {
      return true;
    }

    //Check for iPad specifically with desktop mode enabled (common case)
    final isIpadWithDesktopAgent = userAgent.contains('macintosh') &&
        window.navigator.maxTouchPoints > 0 &&
        !userAgent.contains('windows');
    if (isIpadWithDesktopAgent) {
      return true;
    }

    // Use more specific criteria for touchscreen devices
    // Check if device has touch capability
    final hasTouchPoints = window.navigator.maxTouchPoints > 0;

    if (hasTouchPoints) {
      // Get screen dimensions - mobile devices have certain characteristics
      final screenWidth = window.screen.width;
      final screenHeight = window.screen.height;

      // Check for typical mobile screen characteristics
      // - Very small screens are almost certainly mobile
      // - Portrait orientation with touch is more likely mobile
      // - High device pixel ratio with touch is more likely mobile
      final isVerySmallScreen = screenWidth < 640;
      final isPortraitOrientation = screenHeight > screenWidth;
      final devicePixelRatio = window.devicePixelRatio;
      final isHighDPR = devicePixelRatio >= 2.5;

      return isVerySmallScreen ||
          (isPortraitOrientation && isHighDPR) ||
          (userAgent.contains('mobile') && hasTouchPoints);
    }

    return false;
  }

  const CatalystPlatform._();
}
