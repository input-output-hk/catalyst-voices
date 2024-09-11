import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';

extension WorkspaceProposalSegmentExt on WorkspaceProposalSegment {
  String localizedName(VoicesLocalizations localizations) {
    return switch (this) {
      WorkspaceProposalSetup() => localizations.workspaceProposalSetup,
    };
  }
}

extension WorkspaceProposalSegmentStepExt on WorkspaceProposalSegmentStep {
  String localizedName(VoicesLocalizations localizations) {
    return switch (this) {
      WorkspaceProposalTitle() => localizations.treasuryCampaignTitle,
      WorkspaceProposalTopicX(:final nr) => 'Other topic $nr',
    };
  }

  String tempDescription() {
    return switch (this) {
      WorkspaceProposalTitle() => 'F14 / Promote Social Entrepreneurs and a '
          'longer title up-to 60 characters',
      WorkspaceProposalTopicX(:final nr) => 'Other topic $nr',
    };
  }
}
