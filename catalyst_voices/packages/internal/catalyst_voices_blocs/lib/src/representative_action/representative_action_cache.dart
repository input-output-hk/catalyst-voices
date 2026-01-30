import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class RepresnetativeActionCubitCache extends Equatable {
  final DateTime? votingSnapshotDate;
  final AccountVotingRole? votingRole;

  const RepresnetativeActionCubitCache({
    this.votingSnapshotDate,
    this.votingRole,
  });

  @override
  List<Object?> get props => [
    votingSnapshotDate,
    votingRole,
  ];

  RepresnetativeActionCubitCache copyWith({
    Optional<DateTime>? votingSnapshotDate,
    Optional<AccountVotingRole>? votingRole,
  }) {
    return RepresnetativeActionCubitCache(
      votingSnapshotDate: votingSnapshotDate.dataOr(this.votingSnapshotDate),
      votingRole: votingRole.dataOr(this.votingRole),
    );
  }
}
