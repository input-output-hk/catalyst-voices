import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class PendingEmailChangeDialog extends StatelessWidget {
  const PendingEmailChangeDialog._();

  @override
  Widget build(BuildContext context) {
    return VoicesDesktopInfoDialog(
      icon: VoicesAssets.icons.informationCircle.buildIcon(color: context.colors.iconsPrimary),
      title: Text(context.l10n.pendingEmailChangeTitle),
      message: Text(context.l10n.pendingEmailChangeMessage),
      subMessage: Text(context.l10n.pendingEmailChangeSubMessage),
      action: VoicesFilledButton(
        onTap: () => Navigator.of(context).pop(),
        child: Text(context.l10n.ok),
      ),
    );
  }

  static Future<void> show(BuildContext context) {
    return VoicesDialog.show<void>(
      context: context,
      routeSettings: const RouteSettings(name: '/pending-email-change'),
      builder: (context) => const PendingEmailChangeDialog._(),
    );
  }
}
