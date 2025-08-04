import 'package:catalyst_voices_services/src/share/strategy/share_strategy.dart';
import 'package:url_launcher/url_launcher.dart';

final class LaunchShareStrategy implements ShareStrategy {
  const LaunchShareStrategy();

  @override
  Future<void> share(Uri uri) async {
    await launchUrl(uri);
  }
}
