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

  String get icon => switch (this) {
        AccountRole.voter => VoicesAssets.images.roleVoter.path,
        AccountRole.proposer => VoicesAssets.images.roleProposer.path,
        AccountRole.drep => VoicesAssets.images.roleDrep.path,
      };
}
