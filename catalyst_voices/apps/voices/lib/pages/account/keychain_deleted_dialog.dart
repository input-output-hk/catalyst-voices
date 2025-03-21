import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class KeychainDeletedDialog extends StatelessWidget {
  const KeychainDeletedDialog._();

  @override
  Widget build(BuildContext context) {
    return VoicesSinglePaneDialog(
      backgroundColor: Theme.of(context).colors.iconsBackground,
      showBorder: true,
      constraints: const BoxConstraints(maxWidth: 648, minWidth: 288),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 36),
            VoicesAssets.icons.checkCircle.buildIcon(
              size: 48,
              color: context.colors.iconsPrimary,
            ),
            const SizedBox(height: 8),
            Text(
              context.l10n.keychainDeletedDialogTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.keychainDeletedDialogSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              context.l10n.keychainDeletedDialogInfo,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            VoicesFilledButton(
              key: const Key('KeychainDeletedDialogCloseButton'),
              onTap: () => Navigator.of(context).pop(),
              child: Text(context.l10n.close),
            ),
            const SizedBox(height: 20),
          ],
        ),
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
