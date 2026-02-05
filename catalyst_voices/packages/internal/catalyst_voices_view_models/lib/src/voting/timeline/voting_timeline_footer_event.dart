import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Event for countdown display in the footer.
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

/// Event for power snapshot display in the footer.
final class VotingTimelineFooterPowerSnapshotEvent extends VotingTimelineFooterEvent {
  final DateTime date;

  const VotingTimelineFooterPowerSnapshotEvent({required this.date});

  @override
  List<Object?> get props => [date];
}
