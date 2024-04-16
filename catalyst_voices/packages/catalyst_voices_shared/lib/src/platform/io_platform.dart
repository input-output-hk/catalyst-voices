import 'dart:io';

import 'package:catalyst_voices_shared/src/platform/platform_key.dart';

final class CatalystPlatform {
  static bool get isAndroid => Platform.isAndroid;

  static bool get isDesktop =>
      Platform.isLinux || Platform.isMacOS || Platform.isWindows;

  static bool get isFuchsia => Platform.isFuchsia;

  static bool get isIOS => Platform.isIOS;

  static bool get isLinux => Platform.isLinux;

  static bool get isMacOS => Platform.isMacOS;

  static bool get isMobile => Platform.isAndroid || Platform.isIOS;

  static bool get isMobileWeb => false;

  static bool get isWeb => false;

  static bool get isWebDesktop => false;

  static bool get isWindows => Platform.isWindows;

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
}
