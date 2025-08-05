import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

final class VotingBallotCache extends Equatable {
  final DateRange? votingTimeline;
  final TimezonePreferences? preferredTimezone;

  const VotingBallotCache({
    this.votingTimeline,
    this.preferredTimezone,
  });

  @override
  List<Object?> get props => [
        votingTimeline,
        preferredTimezone,
      ];

  VotingBallotCache copyWith({
    Optional<DateRange>? votingTimeline,
    Optional<TimezonePreferences>? preferredTimezone,
  }) {
    return VotingBallotCache(
      votingTimeline: votingTimeline.dataOr(this.votingTimeline),
      preferredTimezone: preferredTimezone.dataOr(this.preferredTimezone),
    );
  }
}
