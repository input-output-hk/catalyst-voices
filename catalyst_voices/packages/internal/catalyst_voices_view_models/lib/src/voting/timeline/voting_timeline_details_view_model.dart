import 'package:catalyst_voices_view_models/src/voting/timeline/voting_timeline_footer_view_model.dart';
import 'package:catalyst_voices_view_models/src/voting/timeline/voting_timeline_phases_view_model.dart';
import 'package:catalyst_voices_view_models/src/voting/timeline/voting_timeline_title_view_model.dart';
import 'package:equatable/equatable.dart';

/// View model for voting timeline header.
final class VotingTimelineDetailsViewModel extends Equatable {
  final VotingTimelineTitleViewModel titleViewModel;
  final VotingTimelinePhasesViewModel phasesViewModel;
  final VotingTimelineFooterViewModel footerViewModel;
  final double campaignProgress;

  const VotingTimelineDetailsViewModel({
    required this.titleViewModel,
    required this.phasesViewModel,
    required this.footerViewModel,
    required this.campaignProgress,
  });

  @override
  List<Object?> get props => [
    titleViewModel,
    phasesViewModel,
    footerViewModel,
    campaignProgress,
  ];

  VotingTimelineDetailsViewModel copyWith({
    VotingTimelineTitleViewModel? titleViewModel,
    VotingTimelinePhasesViewModel? phasesViewModel,
    VotingTimelineFooterViewModel? footerViewModel,
    double? campaignProgress,
  }) {
    return VotingTimelineDetailsViewModel(
      titleViewModel: titleViewModel ?? this.titleViewModel,
      phasesViewModel: phasesViewModel ?? this.phasesViewModel,
      footerViewModel: footerViewModel ?? this.footerViewModel,
      campaignProgress: campaignProgress ?? this.campaignProgress,
    );
  }
}
