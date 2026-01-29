import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/src/actions/actions_page_tab.dart';
import 'package:flutter/widgets.dart';

/// Represents a type of action card that can be displayed to the user.
///
/// Card types can carry state (e.g., isSet) to adapt their behavior
/// based on user context without needing separate classes.
sealed class ActionsCardType {
  final ActionsPageTab associatedTab;

  const ActionsCardType(this.associatedTab);

  String labelText(BuildContext context);

  String title(BuildContext context);

  static List<ActionsCardType> valuesForTab(ActionsPageTab tab) {
    final allCards = <ActionsCardType>[
      const ProposalApprovalCardType(),
      const DisplayConsentCardType(),
      const RepresentativeCardType(),
      const VotingPowerDelegationCardType(),
      const BecomeReviewerCardType(),
    ];

    if (tab == ActionsPageTab.all) {
      return allCards;
    }

    return allCards.where((card) => card.associatedTab == tab).toList();
  }
}

final class BecomeReviewerCardType extends ActionsCardType {
  const BecomeReviewerCardType() : super(ActionsPageTab.external);

  @override
  String labelText(BuildContext context) {
    return context.l10n.participationPreferences;
  }

  @override
  String title(BuildContext context) {
    return context.l10n.becomeCommunityReviewer;
  }
}

final class DisplayConsentCardType extends ActionsCardType {
  const DisplayConsentCardType() : super(ActionsPageTab.approvals);

  @override
  String labelText(BuildContext context) {
    return context.l10n.participationPreferences;
  }

  @override
  String title(BuildContext context) {
    return context.l10n.collaboratorDisplayConsent;
  }
}

final class ProposalApprovalCardType extends ActionsCardType {
  const ProposalApprovalCardType() : super(ActionsPageTab.approvals);

  @override
  String labelText(BuildContext context) {
    return context.l10n.participationPreferences;
  }

  @override
  String title(BuildContext context) {
    return context.l10n.finalProposalApproval;
  }
}

final class RepresentativeCardType extends ActionsCardType {
  final bool isSet;

  const RepresentativeCardType({this.isSet = false}) : super(ActionsPageTab.role);

  @override
  String labelText(BuildContext context) {
    return context.l10n.participationPreferences;
  }

  @override
  String title(BuildContext context) {
    return isSet ? context.l10n.manageRepresentative : context.l10n.becomeARepresentative;
  }
}

final class VotingPowerDelegationCardType extends ActionsCardType {
  final bool isSet;

  const VotingPowerDelegationCardType({this.isSet = false}) : super(ActionsPageTab.role);

  @override
  String labelText(BuildContext context) {
    return context.l10n.participationPreferences;
  }

  @override
  String title(BuildContext context) {
    return isSet ? context.l10n.manageDelegation : context.l10n.delegateYourVotingPower;
  }
}
