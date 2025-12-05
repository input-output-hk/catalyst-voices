import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class ProposalAcceptInvitationDialog {
  static Future<bool?> show(BuildContext context) {
    return VoicesDialog.show<bool>(
      context: context,
      builder: (context) {
        return VoicesInfoDialog(
          iconThemeData: IconThemeData(
            color: Theme.of(context).colors.iconsForeground,
          ),
          icon: VoicesAssets.icons.documentText.buildIcon(),
          title: Text(context.l10n.collaboratorInvitationAcceptTitle),
          message: Text(context.l10n.collaboratorInvitationAcceptMessage),
          action: VoicesFilledButton(
            child: Text(context.l10n.collaboratorInvitationAcceptButton),
            onTap: () => Navigator.of(context).pop(true),
          ),
        );
      },
      routeSettings: const RouteSettings(name: '/proposal/accept-invitation'),
    );
  }
}

class ProposalRejectInvitationDialog {
  static Future<bool?> show(BuildContext context) {
    return VoicesDialog.show<bool>(
      context: context,
      builder: (context) {
        return VoicesInfoDialog(
          icon: VoicesAssets.icons.documentText.buildIcon(
            color: Theme.of(context).colors.iconsForeground,
          ),
          title: Text(context.l10n.collaboratorInvitationRejectTitle),
          message: Text(context.l10n.collaboratorInvitationRejectMessage),
          action: VoicesFilledButton(
            child: Text(context.l10n.collaboratorInvitationRejectButton),
            onTap: () => Navigator.of(context).pop(true),
          ),
        );
      },
      routeSettings: const RouteSettings(name: '/proposal/reject-invitation'),
    );
  }
}
