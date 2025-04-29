import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class VerificationRequiredDialog extends StatelessWidget {
  const VerificationRequiredDialog._();

  @override
  Widget build(BuildContext context) {
    return VoicesDesktopInfoDialog(
      icon: VoicesAssets.icons.exclamation
          .buildIcon(color: context.colors.iconsWarning),
      title: Text(context.l10n.emailNotVerifiedDialogTitle),
      message: Text(context.l10n.emailNotVerifiedDialogMessage),
      action: VoicesFilledButton(
        onTap: () => Navigator.of(context).pop(),
        child: Text(context.l10n.ok),
      ),
    );
  }

  static Future<void> show(BuildContext context) {
    return VoicesDialog.show<void>(
      context: context,
      routeSettings: const RouteSettings(name: '/verification-required'),
      builder: (context) => const VerificationRequiredDialog._(),
    );
  }
}
