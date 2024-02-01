import 'dart:io';

import 'package:catalyst_voices_shared/src/platform/platform_interface.dart';

final class CatalystPlatform extends PlatformInterface {
  @override
  bool isAndroid() => Platform.isAndroid;

  @override
  bool isDesktop() =>
      Platform.isLinux || Platform.isMacOS || Platform.isWindows;

  @override
  bool isFuchsia() => Platform.isFuchsia;

  @override
  bool isIOS() => Platform.isIOS;

  @override
  bool isLinux() => Platform.isLinux;

  @override
  bool isMacOS() => Platform.isMacOS;

  @override
  bool isMobile() => Platform.isAndroid || Platform.isIOS;

  @override
  bool isMobileWeb() => false;

  @override
  bool isWebDesktop() => false;

  @override
  bool isWindows() => Platform.isWindows;
}
