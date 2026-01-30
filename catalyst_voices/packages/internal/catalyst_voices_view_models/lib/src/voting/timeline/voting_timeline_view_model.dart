import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/src/voting/timeline/voting_timeline_details_view_model.dart';
import 'package:catalyst_voices_view_models/src/voting/timeline/voting_timeline_footer_event.dart';
import 'package:catalyst_voices_view_models/src/voting/timeline/voting_timeline_footer_view_model.dart';
import 'package:catalyst_voices_view_models/src/voting/timeline/voting_timeline_phase_view_model.dart';
import 'package:catalyst_voices_view_models/src/voting/timeline/voting_timeline_phases_view_model.dart';
import 'package:catalyst_voices_view_models/src/voting/timeline/voting_timeline_title_view_model.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

export 'voting_timeline_date_counter_view_model.dart';
export 'voting_timeline_details_view_model.dart';
export 'voting_timeline_footer_event.dart';
export 'voting_timeline_footer_view_model.dart';
export 'voting_timeline_phase_view_model.dart';
export 'voting_timeline_phases_view_model.dart';
export 'voting_timeline_title_view_model.dart';

final class VotingTimelineProgressViewModel extends Equatable {
  final List<VotingTimelinePhase> phases;
  final DateTime? snapshotDate;

  const VotingTimelineProgressViewModel({
    this.phases = const [],
    this.snapshotDate,
  });

  factory VotingTimelineProgressViewModel.fromTimeline(CampaignTimeline timeline) {
    final phases = <VotingTimelinePhase>[];

    // pre-voting = campaign start -> beginning of community voting
    final communityVoting = timeline.phase(CampaignPhaseType.communityVoting);
    if (communityVoting != null) {
      final preVotingRange = DateRange(
        from: timeline.campaignStartDate,
        to: communityVoting.timeline.from,
      );
      final preVoting = VotingTimelinePhase(
        type: VotingTimelinePhaseType.preVoting,
        dateRange: preVotingRange,
      );
      phases
        ..add(preVoting)
        ..add(VotingTimelinePhase.fromCampaignPhase(communityVoting));
    }

    final tally = timeline.phase(CampaignPhaseType.votingTally);
    if (tally != null) {
      phases.add(VotingTimelinePhase.fromCampaignPhase(tally));
    }

    final results = timeline.phase(CampaignPhaseType.votingResults);
    if (results != null) {
      phases.add(VotingTimelinePhase.fromCampaignPhase(results));
    }

    return VotingTimelineProgressViewModel(
      phases: phases,
      snapshotDate: timeline.votingSnapshotDate,
    );
  }

  @override
  List<Object?> get props => [
    phases,
    snapshotDate,
  ];

  VotingTimelineDetailsViewModel? progress({
    required DateTime now,
    required bool phasesExpanded,
    required bool isVotingDelegated,
  }) {
    if (phases.isEmpty) {
      return null;
    }
    final snapshotDate = this.snapshotDate;
    final phaseViewModels = phases
        .map((phase) => VotingTimelinePhaseViewModel.fromModel(phase, now))
        .toList();

    // Find active phase or fallback to first upcoming or last ended phase
    var currentPhase = phaseViewModels.firstWhereOrNull((p) => p.isActive);
    currentPhase ??= phaseViewModels.firstWhereOrNull(
      (p) => p.rangeStatus == DateRangeStatus.before,
    );
    currentPhase ??= phaseViewModels.last;

    // Calculate campaign progress (from first phase start to last phase end)
    final campaignStart = phaseViewModels.first.dateRange.from;
    final campaignEnd = phaseViewModels.last.dateRange.to;

    if (campaignStart == null || campaignEnd == null) {
      return null;
    }

    final double campaignProgress;
    if (now.isBefore(campaignStart)) {
      campaignProgress = 0;
    } else if (now.isAfter(campaignEnd)) {
      campaignProgress = 1;
    } else {
      final campaignDuration = campaignEnd.difference(campaignStart);
      final campaignElapsedTime = now.difference(campaignStart);
      campaignProgress = campaignElapsedTime.inMicroseconds / campaignDuration.inMicroseconds;
    }

    // Calculate countdown to next phase start
    final currentPhaseIndex = phaseViewModels.indexOf(currentPhase);
    final nextPhase = currentPhaseIndex < phaseViewModels.length - 1
        ? phaseViewModels[currentPhaseIndex + 1]
        : null;
    final targetDate = nextPhase?.dateRange.from ?? currentPhase.dateRange.to;
    final nextPhaseStartsIn = (targetDate == null || now.isAfter(targetDate))
        ? Duration.zero
        : targetDate.difference(now);

    final footerLeftEvent = snapshotDate != null
        ? VotingTimelineFooterPowerSnapshotEvent(date: snapshotDate)
        : null;
    final footerRightEvent = VotingTimelineFooterCountdownEvent(
      phaseType: currentPhase.type,
      duration: nextPhaseStartsIn,
    );

    // Show category picker when current phase is voting
    final showCategoryPicker = currentPhase.type == VotingTimelinePhaseType.voting;

    return VotingTimelineDetailsViewModel(
      titleViewModel: VotingTimelineTitleViewModel(
        phaseType: currentPhase.type,
        phasesExpanded: phasesExpanded,
        showCategoryPicker: showCategoryPicker,
        isVotingDelegated: isVotingDelegated,
      ),
      phasesViewModel: VotingTimelinePhasesViewModel(
        phases: phaseViewModels,
        isVotingDelegated: isVotingDelegated,
      ),
      footerViewModel: VotingTimelineFooterViewModel(
        leftEvent: footerLeftEvent,
        rightEvent: footerRightEvent,
      ),
      campaignProgress: campaignProgress,
    );
  }
}
