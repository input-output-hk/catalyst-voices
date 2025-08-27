import 'package:flutter/foundation.dart';

/// The operating system of the user device.
///
/// For flutter web it will be the operating system on which the browser is running.
enum CatalystOperatingSystem {
  android,
  fuchsia,
  iOS,
  linux,
  macOS,
  windows;

  /// The operating system the application is running on currently.
  static CatalystOperatingSystem get current {
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => CatalystOperatingSystem.android,
      TargetPlatform.fuchsia => CatalystOperatingSystem.fuchsia,
      TargetPlatform.iOS => CatalystOperatingSystem.iOS,
      TargetPlatform.linux => CatalystOperatingSystem.linux,
      TargetPlatform.macOS => CatalystOperatingSystem.macOS,
      TargetPlatform.windows => CatalystOperatingSystem.windows,
    };
  }

  static bool get isAndroid => current == CatalystOperatingSystem.android;

  static bool get isFuchsia => current == CatalystOperatingSystem.fuchsia;

  static bool get isIOS => current == CatalystOperatingSystem.iOS;

  static bool get isLinux => current == CatalystOperatingSystem.linux;

  static bool get isMacOS => current == CatalystOperatingSystem.macOS;

  static bool get isWindows => current == CatalystOperatingSystem.windows;
}
