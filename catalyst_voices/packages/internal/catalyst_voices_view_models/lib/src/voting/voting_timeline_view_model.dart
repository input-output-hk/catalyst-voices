import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

final class VotingTimelineDetailsViewModel extends Equatable {
  final VotingTimelinePhaseViewModel currentPhase;
  final Duration currentPhaseEndsIn;
  final double currentPhaseProgress;
  final List<VotingTimelinePhaseViewModel> phases;
  final DateTime? snapshotDate;

  const VotingTimelineDetailsViewModel({
    required this.currentPhase,
    required this.currentPhaseEndsIn,
    required this.currentPhaseProgress,
    required this.phases,
    required this.snapshotDate,
  });

  @override
  List<Object?> get props => [
    currentPhase,
    currentPhaseEndsIn,
    currentPhaseProgress,
    phases,
    snapshotDate,
  ];
}

final class VotingTimelineProgressViewModel extends Equatable {
  final DateRange? votingDateRange;

  /// The starting date of a phase that precedes the voting phase.
  ///
  /// Usually this is needed when voting hasn't yet started
  /// to show a progress bar when the voting starts.
  final DateTime? campaignStartDate;
  final List<VotingTimelinePhase> phases;

  const VotingTimelineProgressViewModel({
    this.votingDateRange,
    this.campaignStartDate,
    this.phases = const [],
  });

  factory VotingTimelineProgressViewModel.fromModel({
    required CampaignPhaseState state,
    required DateTime campaignStartDate,
    required List<VotingTimelinePhase> phases,
  }) {
    return VotingTimelineProgressViewModel(
      votingDateRange: state.phase.timeline,
      campaignStartDate: campaignStartDate,
      phases: phases,
    );
  }

  @override
  List<Object?> get props => [
    votingDateRange,
    campaignStartDate,
    phases,
  ];

  VotingTimelineDetailsViewModel? progress(DateTime now) {
    final votingDateRange = this.votingDateRange;
    if (votingDateRange == null) return null;

    DateTime start;
    DateTime end;

    final status = CampaignPhaseStatus.fromRange(votingDateRange, now);
    switch (status) {
      case CampaignPhaseStatus.upcoming:
        start = campaignStartDate ?? now;
        end = votingDateRange.from ?? now;

      case CampaignPhaseStatus.active:
      case CampaignPhaseStatus.post:
        start = votingDateRange.from ?? now;
        end = votingDateRange.to ?? now;
    }

    final phases2 = phases
        .map((phase) => VotingTimelinePhaseViewModel.fromModel(phase, now))
        .toList();

    final currentPhase = phases2.firstWhereOrNull((p) => p.isActive);
    if (currentPhase == null) return null;

    // Get snapshot date from registration phase
    final registrationPhase = phases.firstWhereOrNull(
      (p) => p.type == VotingTimelinePhaseType.registration,
    );
    final snapshotDate = registrationPhase?.dateRange.to;

    if (now.isBefore(start) || now.isAtSameMomentAs(start)) {
      return VotingTimelineDetailsViewModel(
        currentPhase: currentPhase,
        currentPhaseEndsIn: Duration.zero,
        currentPhaseProgress: 0,
        phases: phases2,
        snapshotDate: snapshotDate,
      );
    } else if (now.isAfter(end) || now.isAtSameMomentAs(end)) {
      return VotingTimelineDetailsViewModel(
        currentPhase: currentPhase,
        currentPhaseEndsIn: Duration.zero,
        currentPhaseProgress: 1,
        phases: phases2,
        snapshotDate: snapshotDate,
      );
    } else {
      final phaseDuration = end.difference(start);
      final phaseCurrentTs = now.difference(start);
      final phaseEndsIn = end.difference(now);
      final phaseValue = phaseCurrentTs.inMicroseconds / phaseDuration.inMicroseconds;

      return VotingTimelineDetailsViewModel(
        currentPhase: currentPhase,
        currentPhaseEndsIn: phaseEndsIn,
        currentPhaseProgress: phaseValue,
        phases: phases2,
        snapshotDate: snapshotDate,
      );
    }
  }
}

final class VotingTimelinePhaseViewModel extends Equatable {
  final VotingTimelinePhaseType type;
  final String title;
  final String description;
  final DateRange dateRange;
  final DateRangeStatus rangeStatus;

  const VotingTimelinePhaseViewModel({
    required this.type,
    required this.title,
    required this.description,
    required this.dateRange,
    required this.rangeStatus,
  });

  factory VotingTimelinePhaseViewModel.fromModel(
    VotingTimelinePhase model,
    DateTime now,
  ) {
    return VotingTimelinePhaseViewModel(
      type: model.type,
      title: model.title,
      description: model.description,
      dateRange: model.dateRange,
      rangeStatus: model.dateRange.rangeStatus(now),
    );
  }

  bool get isActive => rangeStatus == DateRangeStatus.inRange;

  @override
  List<Object?> get props => [
    type,
    title,
    description,
    dateRange,
    rangeStatus,
  ];
}
