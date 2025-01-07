import 'package:url_launcher/url_launcher.dart';

mixin LaunchUrlMixin {
  Future<void> launchHrefUrl(Uri url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
}
