import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class MockUrlLauncherPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {
  late UrlLauncherPlatform originalPlatform;
  String capturedUrl = '';

  MockUrlLauncherPlatform() {
    originalPlatform = UrlLauncherPlatform.instance;
    UrlLauncherPlatform.instance = this;
  }

  void tearDownMock() {
    UrlLauncherPlatform.instance = originalPlatform;
    reset(this);
    capturedUrl = '';
  }

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    capturedUrl = url;
    return true;
  }

  @override
  Future<bool> canLaunch(String url) async {
    return true;
  }
}
