import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

extension VoteTypeViewModel on VoteType {
  SvgGenImage icon() {
    return switch (this) {
      VoteType.yes => VoicesAssets.icons.thumbUp,
      VoteType.abstain => VoicesAssets.icons.minus,
    };
  }

  String localizedName(
    BuildContext context, {
    bool present = true,
  }) {
    return switch (this) {
      VoteType.yes => present ? context.l10n.voteYes : context.l10n.votedYes,
      VoteType.abstain => present ? context.l10n.voteAbstain : context.l10n.votedAbstain,
    };
  }
}
