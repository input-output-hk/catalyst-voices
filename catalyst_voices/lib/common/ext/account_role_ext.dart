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
          'Select favorites',
          'Comment/Vote on Proposals',
          'Cast your votes',
          'Voter rewards',
        ];
      case AccountRole.proposer:
        return [
          'Write/edit functionality',
          'Rights to Submit to Fund',
          'Invite Team Members',
          'Comment functionality',
        ];
      case AccountRole.drep:
        return [
          'Delegated Votes',
          'dRep rewards',
          'Cast delegated votes',
          'Comment Functionality',
        ];
    }
  }

  String get avatarPath {
    switch (this) {
      case AccountRole.voter:
        return VoicesAssets.images.roleInfoVoter.path;
      case AccountRole.proposer:
        return VoicesAssets.images.roleInfoProposer.path;
      case AccountRole.drep:
        return VoicesAssets.images.roleInfoDrep.path;
    }
  }

  String get icon => switch (this) {
        AccountRole.voter => VoicesAssets.images.roleVoter.path,
        AccountRole.proposer => VoicesAssets.images.roleProposer.path,
        AccountRole.drep => VoicesAssets.images.roleDrep.path,
      };
}
