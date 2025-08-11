import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

final class VotingPhaseProgressDetailsViewModel extends Equatable {
  final CampaignPhaseStatus status;
  final DateRange? votingDateRange;
  final Duration phaseEndsIn;
  final double progressValue;

  const VotingPhaseProgressDetailsViewModel({
    required this.status,
    required this.votingDateRange,
    required this.phaseEndsIn,
    required this.progressValue,
  });

  @override
  List<Object?> get props => [status, votingDateRange, phaseEndsIn, progressValue];
}

final class VotingPhaseProgressViewModel extends Equatable {
  final DateRange? votingDateRange;

  /// The starting date of a phase that precedes the voting phase.
  ///
  /// Usually this is needed when voting hasn't yet started
  /// to show a progress bar when the voting starts.
  final DateTime? campaignStartDate;

  const VotingPhaseProgressViewModel({
    this.votingDateRange,
    this.campaignStartDate,
  });

  factory VotingPhaseProgressViewModel.fromModel({
    required CampaignPhaseState state,
    required DateTime campaignStartDate,
  }) {
    return VotingPhaseProgressViewModel(
      votingDateRange: state.phase.timeline,
      campaignStartDate: campaignStartDate,
    );
  }

  @override
  List<Object?> get props => [votingDateRange, campaignStartDate];

  VotingPhaseProgressDetailsViewModel? progress(DateTime now) {
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

    if (now.isBefore(start) || now.isAtSameMomentAs(start)) {
      return VotingPhaseProgressDetailsViewModel(
        status: status,
        votingDateRange: votingDateRange,
        phaseEndsIn: Duration.zero,
        progressValue: 0,
      );
    } else if (now.isAfter(end) || now.isAtSameMomentAs(end)) {
      return VotingPhaseProgressDetailsViewModel(
        status: status,
        votingDateRange: votingDateRange,
        phaseEndsIn: Duration.zero,
        progressValue: 1,
      );
    } else {
      final phaseDuration = end.difference(start);
      final phaseCurrentTs = now.difference(start);
      final phaseEndsIn = end.difference(now);
      final phaseValue = phaseCurrentTs.inMicroseconds / phaseDuration.inMicroseconds;

      return VotingPhaseProgressDetailsViewModel(
        status: status,
        votingDateRange: votingDateRange,
        phaseEndsIn: phaseEndsIn,
        progressValue: phaseValue,
      );
    }
  }
}
