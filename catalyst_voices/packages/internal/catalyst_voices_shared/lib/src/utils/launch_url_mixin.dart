import 'package:url_launcher/url_launcher.dart';

// TODO(ryszard-schossler): in future we can create error handling solution for this
// mixin LaunchUrlMixin<T extends StatefulWidget> on State<T>
mixin LaunchUrlMixin {
  Future<void> launchHrefUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
