import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class MockUrlLauncherPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {
  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    print('^^^.Launching url1: $url');
    return true; // Simulate success
  }

  @override
  Future<bool> canLaunch(String url) async {
    return true; // Simulate can launch
  }

  Future<bool> canLaunchUrl(String url) async {
    print('^^^.Can launch url');
    return true; // Simulate can launch
  }

  // @override
  // void closeWebView() {} // No implementation needed for this test
}
