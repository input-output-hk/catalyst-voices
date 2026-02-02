import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// View model for voting timeline title widget.
final class VotingTimelineTitleViewModel extends Equatable {
  final VotingTimelinePhaseType phaseType;
  final bool phasesExpanded;
  final bool showCategoryPicker;
  final bool isVotingDelegated;

  const VotingTimelineTitleViewModel({
    required this.phaseType,
    required this.phasesExpanded,
    required this.showCategoryPicker,
    required this.isVotingDelegated,
  });

  @override
  List<Object?> get props => [
    phaseType,
    phasesExpanded,
    showCategoryPicker,
    isVotingDelegated,
  ];

  VotingTimelineTitleViewModel copyWith({
    VotingTimelinePhaseType? phaseType,
    bool? phasesExpanded,
    bool? showCategoryPicker,
    bool? isVotingDelegated,
  }) {
    return VotingTimelineTitleViewModel(
      phaseType: phaseType ?? this.phaseType,
      phasesExpanded: phasesExpanded ?? this.phasesExpanded,
      showCategoryPicker: showCategoryPicker ?? this.showCategoryPicker,
      isVotingDelegated: isVotingDelegated ?? this.isVotingDelegated,
    );
  }
}
