import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/widgets.dart';

enum ProposalCommentsSort {
  newest,
  oldest;

  String localizedLabel(BuildContext context) {
    return switch (this) {
      ProposalCommentsSort.newest => context.l10n.proposalCommentsSortNewest,
      ProposalCommentsSort.oldest => context.l10n.proposalCommentsSortOldest,
    };
  }
}
