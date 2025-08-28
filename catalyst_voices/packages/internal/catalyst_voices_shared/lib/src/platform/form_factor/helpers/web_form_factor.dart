import 'dart:ui';

import 'package:catalyst_voices_shared/src/platform/form_factor/form_factor.dart';
import 'package:flutter/foundation.dart';
import 'package:web/web.dart';

bool get isDesktopFormFactor => !isMobileFormFactor;

bool get isMobileFormFactor {
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
    case TargetPlatform.iOS:
      return _isMobileWebFormFactor;

    case TargetPlatform.linux:
    case TargetPlatform.macOS:
    case TargetPlatform.windows:
      return false;
  }
}

bool get _isMobileWebFormFactor {
  final hasTouchPoints = window.navigator.maxTouchPoints > 0;
  final isVerySmallScreen =
      window.screen.size.shortestSide < CatalystFormFactor.mobileScreenSizeBreakpoint;

  return hasTouchPoints && isVerySmallScreen;
}

extension on Screen {
  Size get size {
    return Size(width.toDouble(), height.toDouble());
  }
}
