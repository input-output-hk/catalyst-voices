import 'package:catalyst_voices_services/src/share/strategy/share_strategy.dart';
import 'package:flutter/services.dart';

final class ClipboardShareStrategy implements ShareStrategy {
  const ClipboardShareStrategy();

  @override
  Future<void> share(Uri uri) async {
    final encoded = uri.toString();
    final decoded = Uri.decodeFull(encoded);

    await Clipboard.setData(ClipboardData(text: decoded));
  }
}
