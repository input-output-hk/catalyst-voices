import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

extension AccountRoleExt on AccountRole {
  SvgGenImage get icon {
    return switch (this) {
      AccountRole.voter => VoicesAssets.images.svg.roleVoter,
      AccountRole.drep => VoicesAssets.images.svg.roleDrep,
      AccountRole.proposer => VoicesAssets.images.svg.roleProposer,
    };
  }

  SvgGenImage get smallIcon {
    return switch (this) {
      AccountRole.voter => VoicesAssets.icons.vote,
      AccountRole.drep => VoicesAssets.icons.documentText,
      AccountRole.proposer => VoicesAssets.icons.badgeCheck,
    };
  }

  String getDescription(BuildContext context) {
    switch (this) {
      case AccountRole.voter:
        return context.l10n.contributorDescription;
      case AccountRole.proposer:
        return context.l10n.proposerDescription;
      case AccountRole.drep:
        return context.l10n.drepDescription;
    }
  }

  String getName(
    BuildContext context, {
    bool addDefaultState = false,
  }) {
    var name = switch (this) {
      AccountRole.voter => context.l10n.contributor,
      AccountRole.proposer => context.l10n.proposer,
      AccountRole.drep => context.l10n.drep,
    };

    if (addDefaultState && isDefault) {
      name = '$name (${context.l10n.defaultRole})';
    }

    return name;
  }

  List<String> getSummary(BuildContext context) {
    switch (this) {
      case AccountRole.voter:
        return [
          context.l10n.contributorSummarySelectFavorites,
          context.l10n.contributorSummaryComment,
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

  String getVerboseName(BuildContext context) {
    switch (this) {
      case AccountRole.voter:
        return context.l10n.contributorVerboseName;
      case AccountRole.proposer:
        return context.l10n.proposerVerboseName;
      case AccountRole.drep:
        return context.l10n.drepVerboseName;
    }
  }
}
