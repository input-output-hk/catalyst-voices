import 'dart:io';

import 'package:catalyst_voices_shared/src/platform/platform_interface.dart';

final class CatalystPlatform extends PlatformInterface {
  @override
  bool get isAndroid => Platform.isAndroid;

  @override
  bool get isDesktop =>
      Platform.isLinux || Platform.isMacOS || Platform.isWindows;

  @override
  bool get isFuchsia => Platform.isFuchsia;

  @override
  bool get isIOS => Platform.isIOS;

  @override
  bool get isLinux => Platform.isLinux;

  @override
  bool get isMacOS => Platform.isMacOS;

  @override
  bool get isMobile => Platform.isAndroid || Platform.isIOS;

  @override
  bool get isMobileWeb => false;

  @override
  bool get isWebDesktop => false;

  @override
  bool get isWindows => Platform.isWindows;
}
