import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/widgets.dart';

enum ProposalCommentsSort {
  newest,
  oldest;

  SvgGenImage get icon {
    return switch (this) {
      ProposalCommentsSort.newest => VoicesAssets.icons.sortDescending,
      ProposalCommentsSort.oldest => VoicesAssets.icons.sortAscending,
    };
  }

  String localizedName(BuildContext context) {
    return switch (this) {
      ProposalCommentsSort.newest => context.l10n.proposalCommentsSortNewest,
      ProposalCommentsSort.oldest => context.l10n.proposalCommentsSortOldest,
    };
  }
}
