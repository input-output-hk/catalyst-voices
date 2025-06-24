import 'package:web/web.dart';

final class CatalystBrowser {
  static bool get isSafari {
    final userAgent = window.navigator.userAgent.toLowerCase();
    return userAgent.contains('safari') && !userAgent.contains('chrome');
  }
}
