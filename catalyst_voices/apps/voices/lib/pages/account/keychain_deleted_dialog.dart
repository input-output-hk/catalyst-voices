import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class KeychainDeletedDialog extends StatelessWidget {
  const KeychainDeletedDialog._();

  @override
  Widget build(BuildContext context) {
    return VoicesDesktopInfoDialog(
      icon: VoicesAssets.icons.checkCircle.buildIcon(),
      title: Text(context.l10n.keychainDeletedDialogTitle),
      message: Text(context.l10n.keychainDeletedDialogSubtitle),
      action: VoicesFilledButton(
        onTap: () => Navigator.of(context).pop(),
        child: Text(context.l10n.close),
      ),
    );
  }

  static Future<void> show(BuildContext context) {
    return VoicesDialog.show<void>(
      context: context,
      routeSettings: const RouteSettings(name: '/deleted-keychain'),
      builder: (context) => const KeychainDeletedDialog._(),
    );
  }
}
