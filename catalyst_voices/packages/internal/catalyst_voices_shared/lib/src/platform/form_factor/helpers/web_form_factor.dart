import 'dart:ui';

import 'package:catalyst_voices_shared/src/platform/form_factor/form_factor.dart';
import 'package:web/web.dart';

bool get isDesktopFormFactor => !isMobileFormFactor;

bool get isMobileFormFactor {
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

  // Check for iPad specifically with desktop mode enabled (common case)
  final isIpadWithDesktopAgent =
      userAgent.contains('macintosh') &&
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
    final screenSize = window.screen.size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    // Check for typical mobile screen characteristics
    // - Very small screens are almost certainly mobile
    // - Portrait orientation with touch is more likely mobile
    // - High device pixel ratio with touch is more likely mobile
    final isVerySmallScreen =
        screenSize.shortestSide < CatalystFormFactor.mobileScreenSizeBreakpoint;
    final isPortraitOrientation = screenHeight > screenWidth;
    final isHighDPR = window.devicePixelRatio >= 2.5;

    return isVerySmallScreen ||
        (isPortraitOrientation && isHighDPR) ||
        (userAgent.contains('mobile') && hasTouchPoints);
  }

  return false;
}

extension on Screen {
  Size get size {
    return Size(width.toDouble(), height.toDouble());
  }
}
