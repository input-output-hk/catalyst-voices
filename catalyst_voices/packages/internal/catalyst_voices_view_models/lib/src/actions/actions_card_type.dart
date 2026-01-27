import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/src/actions/actions_page_tab.dart';
import 'package:flutter/widgets.dart';

enum ActionsCardType {
  proposalApproval(ActionsPageTab.approvals),
  displayConsent(ActionsPageTab.approvals),
  representative(ActionsPageTab.role),
  // TODO(LynxLynxx): Verify what page tab voting power should be associated with
  votingPower(ActionsPageTab.role),
  becomeReviewer(ActionsPageTab.external);

  final ActionsPageTab associatedTab;

  const ActionsCardType(this.associatedTab);

  String labelText(BuildContext context) {
    final l10n = context.l10n;

    return switch (this) {
      ActionsCardType.votingPower => '',
      _ => l10n.participationPreferences,
    };
  }

  String title(BuildContext context) {
    final l10n = context.l10n;

    return switch (this) {
      ActionsCardType.proposalApproval => l10n.finalProposalApproval,
      ActionsCardType.displayConsent => l10n.collaboratorDisplayConsent,
      ActionsCardType.representative => l10n.becomeARepresentative,
      ActionsCardType.becomeReviewer => l10n.becomeCommunityReviewer,
      ActionsCardType.votingPower => '',
    };
  }
}
