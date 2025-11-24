import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';

enum WorkspaceFilters {
  allProposals,
  mainProposer,
  collaborator;

  const WorkspaceFilters();

  String localizedName(VoicesLocalizations l10n) {
    return switch (this) {
      allProposals => l10n.allProposals,
      mainProposer => l10n.mainProposer,
      collaborator => l10n.collaborator,
    };
  }
}
