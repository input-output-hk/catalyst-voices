import 'package:url_launcher/url_launcher.dart';

// TODO(LynxLynxx): in future we can create error handling
// solution for this mixin LaunchUrlMixin<T extends StatefulWidget> on State<T>
mixin LaunchUrlMixin {
  Future<void> launchUri(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
