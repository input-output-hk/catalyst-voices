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
