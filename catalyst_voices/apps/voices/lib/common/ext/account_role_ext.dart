import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

extension AccountRoleExt on AccountRole {
  String getName(BuildContext context) {
    switch (this) {
      case AccountRole.voter:
        return context.l10n.voter;
      case AccountRole.proposer:
        return context.l10n.proposer;
      case AccountRole.drep:
        return context.l10n.drep;
    }
  }

  String getVerboseName(BuildContext context) {
    switch (this) {
      case AccountRole.voter:
        return context.l10n.voterVerboseName;
      case AccountRole.proposer:
        return context.l10n.proposerVerboseName;
      case AccountRole.drep:
        return context.l10n.drepVerboseName;
    }
  }

  String getDescription(BuildContext context) {
    switch (this) {
      case AccountRole.voter:
        return context.l10n.voterDescription;
      case AccountRole.proposer:
        return context.l10n.proposerDescription;
      case AccountRole.drep:
        return context.l10n.drepDescription;
    }
  }

  List<String> getSummary(BuildContext context) {
    switch (this) {
      case AccountRole.voter:
        return [
          context.l10n.voterSummarySelectFavorites,
          context.l10n.voterSummaryComment,
          context.l10n.voterSummaryCastVotes,
          context.l10n.voterSummaryVoterRewards,
        ];
      case AccountRole.proposer:
        return [
          context.l10n.proposerSummaryWriteEdit,
          context.l10n.proposerSummarySubmitToFund,
          context.l10n.proposerSummaryInviteTeamMembers,
          context.l10n.proposerSummaryComment,
        ];
      case AccountRole.drep:
        return [
          context.l10n.drepSummaryDelegatedVotes,
          context.l10n.drepSummaryRewards,
          context.l10n.drepSummaryCastVotes,
          context.l10n.drepSummaryComment,
        ];
    }
  }

  SvgGenImage get icon {
    return switch (this) {
      AccountRole.voter => VoicesAssets.images.roleVoter,
      AccountRole.drep => VoicesAssets.images.roleDrep,
      AccountRole.proposer => VoicesAssets.images.roleProposer,
    };
  }
}
