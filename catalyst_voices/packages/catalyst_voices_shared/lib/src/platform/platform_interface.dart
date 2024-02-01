class CatalystPlatform {}

abstract class PlatformInterface {
  bool isAndroid();
  bool isDesktop();
  bool isFuchsia();
  bool isIOS();
  bool isLinux();
  bool isMacOS();
  bool isMobile();
  bool isMobileWeb();
  bool isWebDesktop();
  bool isWindows();
}
