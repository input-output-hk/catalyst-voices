class CatalystPlatform {}

abstract class PlatformInterface {
  bool get isAndroid;
  bool get isDesktop;
  bool get isFuchsia;
  bool get isIOS;
  bool get isLinux;
  bool get isMacOS;
  bool get isMobile;
  bool get isMobileWeb;
  bool get isWebDesktop;
  bool get isWindows;
}
