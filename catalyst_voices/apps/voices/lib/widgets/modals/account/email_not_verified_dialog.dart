import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class EmailNotVerifiedDialog extends StatelessWidget {
  const EmailNotVerifiedDialog._();

  @override
  Widget build(BuildContext context) {
    return VoicesDesktopInfoDialog(
      icon: VoicesAssets.icons.exclamation
          .buildIcon(color: context.colors.warning),
      title: Text(context.l10n.emailNotVerifiedDialogTitle),
      message: Text(context.l10n.emailNotVerifiedDialogMessage),
      action: const Row(
        spacing: 12,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _MyAccountButton(),
          _CancelButton(),
        ],
      ),
    );
  }

  /// Returns true if should open account page.
  static Future<bool> show(BuildContext context) {
    return VoicesDialog.show<bool>(
      context: context,
      builder: (_) => const EmailNotVerifiedDialog._(),
      routeSettings: const RouteSettings(name: '/email-not-verified'),
    ).then((value) => value ?? false);
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton();

  @override
  Widget build(BuildContext context) {
    return VoicesTextButton(
      onTap: () => Navigator.of(context).pop(false),
      child: Text(context.l10n.cancelButtonText),
    );
  }
}

class _MyAccountButton extends StatelessWidget {
  const _MyAccountButton();

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      onTap: () => Navigator.of(context).pop(true),
      child: Text(context.l10n.emailNotVerifiedDialogAction),
    );
  }
}
