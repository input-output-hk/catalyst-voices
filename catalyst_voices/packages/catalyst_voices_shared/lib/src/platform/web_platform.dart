// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:html';

import 'package:catalyst_voices_shared/src/platform/platform_interface.dart';
import 'package:flutter/foundation.dart';

final class CatalystPlatform extends PlatformInterface {
  @override
  bool isAndroid() => false;

  @override
  bool isDesktop() => false;

  @override
  bool isFuchsia() => false;

  @override
  bool isIOS() => false;

  @override
  bool isLinux() => false;

  @override
  bool isMacOS() => false;

  @override
  bool isMobile() => false;

  @override
  bool isMobileWeb() => _isMobileOS();

  @override
  bool isWebDesktop() => kIsWeb && !_isMobileOS();

  @override
  bool isWindows() => false;

  static bool _isMobileOS() {
    final userAgent = window.navigator.userAgent.toLowerCase();
    if (userAgent.contains('iphone')) return true;
    if (userAgent.contains('ipad')) return true;
    if (userAgent.contains('android')) return true;
    return false;
  }
}
