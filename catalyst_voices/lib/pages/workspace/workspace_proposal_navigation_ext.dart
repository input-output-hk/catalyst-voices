import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';

extension WorkspaceProposalSegmentExt on WorkspaceProposalSegment {
  String localizedName(VoicesLocalizations localizations) {
    return switch (this) {
      WorkspaceProposalSetup() => localizations.workspaceProposalSetup,
      WorkspaceProposalSummary() => 'Proposal summary',
      WorkspaceProposalSolution() => 'Proposal solution',
      WorkspaceProposalImpact() => 'Proposal Impact',
      WorkspaceProposalCapabilityAndFeasibility() => 'Capability & Feasibility',
    };
  }
}
