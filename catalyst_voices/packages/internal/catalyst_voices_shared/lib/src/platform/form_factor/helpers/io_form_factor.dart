import 'package:catalyst_voices_shared/src/platform/form_factor/form_factor.dart';
import 'package:flutter/foundation.dart';

bool get isDesktopFormFactor => !isMobileFormFactor;

bool get isMobileFormFactor {
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
    case TargetPlatform.fuchsia:
    case TargetPlatform.iOS:
      final display = PlatformDispatcher.instance.displays.first;
      final screenSize = display.size.shortestSide / display.devicePixelRatio;
      return screenSize < CatalystFormFactor.mobileScreenSizeBreakpoint;

    case TargetPlatform.linux:
    case TargetPlatform.macOS:
    case TargetPlatform.windows:
      return false;
  }
}
