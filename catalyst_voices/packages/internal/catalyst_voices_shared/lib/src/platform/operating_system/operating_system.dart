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

  bool get isAndroid => this == CatalystOperatingSystem.android;

  bool get isFuchsia => this == CatalystOperatingSystem.fuchsia;

  bool get isIOS => this == CatalystOperatingSystem.iOS;

  bool get isLinux => this == CatalystOperatingSystem.linux;

  bool get isMacOS => this == CatalystOperatingSystem.macOS;

  bool get isMobile => isAndroid || isIOS;

  bool get isWindows => this == CatalystOperatingSystem.windows;
}
