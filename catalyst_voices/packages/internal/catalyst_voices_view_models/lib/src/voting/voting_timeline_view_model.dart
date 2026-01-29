import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

/// Type of date counter display.
enum VotingTimelineDateCounterType {
  /// Show "Starting in X days"
  startingIn,

  /// Show "Starting" with date
  startingWithDate,

  /// Show "Ended X days ago"
  endedDaysAgo,

  /// Show "Ended" with date
  endedWithDate,

  /// Counter is hidden (e.g., for active phases)
  hidden,
}

/// View model for date counter in phase cards.
final class VotingTimelineDateCounterViewModel extends Equatable {
  final VotingTimelineDateCounterType type;
  final int daysCount;
  final DateTime date;

  const VotingTimelineDateCounterViewModel({
    required this.type,
    required this.daysCount,
    required this.date,
  });

  @override
  List<Object?> get props => [type, daysCount, date];
}

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

final class VotingTimelineFooterCountdownEvent extends VotingTimelineFooterEvent {
  final VotingTimelinePhaseType phaseType;
  final Duration duration;

  const VotingTimelineFooterCountdownEvent({
    required this.phaseType,
    required this.duration,
  });

  @override
  List<Object?> get props => [phaseType, duration];
}

/// Sealed class for footer events.
sealed class VotingTimelineFooterEvent extends Equatable {
  const VotingTimelineFooterEvent();
}

final class VotingTimelineFooterPowerSnapshotEvent extends VotingTimelineFooterEvent {
  final DateTime date;

  const VotingTimelineFooterPowerSnapshotEvent({required this.date});

  @override
  List<Object?> get props => [date];
}

/// View model for voting timeline footer widget.
final class VotingTimelineFooterViewModel extends Equatable {
  final VotingTimelineFooterEvent? leftEvent;
  final VotingTimelineFooterEvent? rightEvent;

  const VotingTimelineFooterViewModel({
    this.leftEvent,
    this.rightEvent,
  });

  @override
  List<Object?> get props => [leftEvent, rightEvent];
}

/// View model for voting timeline phases widget.
final class VotingTimelinePhasesViewModel extends Equatable {
  final List<VotingTimelinePhaseViewModel> phases;
  final bool isVotingDelegated;

  const VotingTimelinePhasesViewModel({
    required this.phases,
    required this.isVotingDelegated,
  });

  @override
  List<Object?> get props => [phases, isVotingDelegated];
}

/// View model for voting timeline phase widget.
final class VotingTimelinePhaseViewModel extends Equatable {
  final VotingTimelinePhaseType type;
  final DateRange dateRange;
  final DateRangeStatus rangeStatus;
  final VotingTimelineDateCounterViewModel dateCounter;

  const VotingTimelinePhaseViewModel({
    required this.type,
    required this.dateRange,
    required this.rangeStatus,
    required this.dateCounter,
  });

  factory VotingTimelinePhaseViewModel.fromModel(
    VotingTimelinePhase model,
    DateTime now,
  ) {
    final rangeStatus = model.dateRange.rangeStatus(now);
    final dateCounter = _buildDateCounter(
      now: now,
      dateRange: model.dateRange,
      rangeStatus: rangeStatus,
    );

    return VotingTimelinePhaseViewModel(
      type: model.type,
      dateRange: model.dateRange,
      rangeStatus: rangeStatus,
      dateCounter: dateCounter,
    );
  }

  bool get isActive => rangeStatus == DateRangeStatus.inRange;

  @override
  List<Object?> get props => [
    type,
    dateRange,
    rangeStatus,
    dateCounter,
  ];

  static VotingTimelineDateCounterViewModel _buildDateCounter({
    required DateTime now,
    required DateRange dateRange,
    required DateRangeStatus rangeStatus,
  }) {
    final startDate = dateRange.from;
    final endDate = dateRange.to;

    if (startDate == null || endDate == null) {
      return VotingTimelineDateCounterViewModel(
        type: VotingTimelineDateCounterType.hidden,
        daysCount: 0,
        date: DateTime(0),
      );
    }

    switch (rangeStatus) {
      case DateRangeStatus.inRange:
        return VotingTimelineDateCounterViewModel(
          type: VotingTimelineDateCounterType.hidden,
          daysCount: 0,
          date: DateTime(0),
        );
      case DateRangeStatus.before:
        var daysUntil = startDate.difference(now).inDays;
        daysUntil = daysUntil == 0 ? 1 : daysUntil;
        final type = daysUntil > 30
            ? VotingTimelineDateCounterType.startingWithDate
            : VotingTimelineDateCounterType.startingIn;
        return VotingTimelineDateCounterViewModel(
          type: type,
          daysCount: daysUntil,
          date: startDate,
        );
      case DateRangeStatus.after:
        var daysSince = now.difference(endDate).inDays;
        daysSince = daysSince == 0 ? 1 : daysSince;
        final type = daysSince > 30
            ? VotingTimelineDateCounterType.endedWithDate
            : VotingTimelineDateCounterType.endedDaysAgo;
        return VotingTimelineDateCounterViewModel(
          type: type,
          daysCount: daysSince,
          date: endDate,
        );
    }
  }
}

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
