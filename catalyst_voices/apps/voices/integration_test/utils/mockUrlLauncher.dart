import 'package:mockito/mockito.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class MockUrlLauncher extends Mock
    with MockPlatformInterfaceMixin
    implements UrlLauncherPlatform {
  @override
  Future<bool> canLaunch(String url) async {
    return true;
  }

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    // throw UnimplementedError();
    print('launchUrl: $url');
    return true;
  }

  @override
  Future<bool> launch(String url,
      {required bool useSafariVC,
      required bool useWebView,
      required bool enableJavaScript,
      required bool enableDomStorage,
      required bool universalLinksOnly,
      required Map<String, String> headers,
      String? webOnlyWindowName}) async {
    return true;
    // throw UnimplementedError();
  }

  // @override
  // TODO: implement linkDelegate
  // LinkDelegate? get linkDelegate => throw UnimplementedError();
}
