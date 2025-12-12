import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';

enum WorkspaceFilters {
  allProposals,
  mainProposer,
  collaborator;

  const WorkspaceFilters();

  bool get isAllProposals => this == allProposals;

  bool get isCollaborator => this == collaborator;

  bool get isMainProposer => this == mainProposer;

  String localizedName(VoicesLocalizations l10n) {
    return switch (this) {
      allProposals => l10n.allProposals,
      mainProposer => l10n.mainProposer,
      collaborator => l10n.collaborator,
    };
  }
}
