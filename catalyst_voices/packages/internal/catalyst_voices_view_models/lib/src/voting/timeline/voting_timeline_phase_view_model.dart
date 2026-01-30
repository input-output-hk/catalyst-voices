import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/src/voting/timeline/voting_timeline_date_counter_view_model.dart';
import 'package:equatable/equatable.dart';

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
