import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/widgets.dart';

enum WorkspaceTabType {
  draftProposal,
  finalProposal;

  String localizedName(
    BuildContext context, {
    required int count,
  }) {
    return switch (this) {
      WorkspaceTabType.draftProposal => context.l10n.draftProposalsX(count),
      WorkspaceTabType.finalProposal => context.l10n.finalProposalsX(count),
    };
  }
}
