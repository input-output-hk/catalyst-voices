import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class ProposalAcceptFinalProposalDialog {
  static Future<bool?> show(BuildContext context) {
    return VoicesDialog.show<bool>(
      context: context,
      builder: (context) {
        return VoicesInfoDialog(
          iconThemeData: IconThemeData(
            color: Theme.of(context).colors.iconsForeground,
          ),
          icon: VoicesAssets.icons.documentText.buildIcon(),
          title: Text(context.l10n.collaboratorFinalProposalAcceptTitle),
          message: Text(context.l10n.collaboratorFinalProposalAcceptMessage),
          action: VoicesFilledButton(
            child: Text(context.l10n.collaboratorFinalProposalAcceptButton),
            onTap: () => Navigator.of(context).pop(true),
          ),
        );
      },
      routeSettings: const RouteSettings(name: '/proposal/accept-final-proposal'),
    );
  }
}

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

class ProposalRejectFinalProposalDialog {
  static Future<bool?> show(BuildContext context) {
    return VoicesDialog.show<bool>(
      context: context,
      builder: (context) {
        return VoicesInfoDialog(
          icon: VoicesAssets.icons.documentText.buildIcon(
            color: Theme.of(context).colors.iconsForeground,
          ),
          title: Text(context.l10n.collaboratorFinalProposalRejectTitle),
          message: Text(context.l10n.collaboratorFinalProposalRejectMessage),
          action: VoicesFilledButton(
            child: Text(context.l10n.collaboratorFinalProposalRejectButton),
            onTap: () => Navigator.of(context).pop(true),
          ),
        );
      },
      routeSettings: const RouteSettings(name: '/proposal/reject-final-proposal'),
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
