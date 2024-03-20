import 'dart:io';

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

  static Map<String, bool> get identifiers => {
    'android': isAndroid,
    'desktop': isDesktop,
    'fuchsia': isFuchsia,
    'iOS': isIOS,
    'linux': isLinux,
    'macOS': isMacOS,
    'mobile': isMobile,
    'mobileWeb': isMobileWeb,
    'web': isWeb,
    'webDesktop': isWebDesktop,
    'windows': isWindows,
  };
}
