import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class RepresentativeActionCubitCache extends Equatable {
  final DateTime? votingSnapshotDate;
  final AccountVotingRole? votingRole;

  const RepresentativeActionCubitCache({
    this.votingSnapshotDate,
    this.votingRole,
  });

  @override
  List<Object?> get props => [
    votingSnapshotDate,
    votingRole,
  ];

  RepresentativeActionCubitCache copyWith({
    Optional<DateTime>? votingSnapshotDate,
    Optional<AccountVotingRole>? votingRole,
  }) {
    return RepresentativeActionCubitCache(
      votingSnapshotDate: votingSnapshotDate.dataOr(this.votingSnapshotDate),
      votingRole: votingRole.dataOr(this.votingRole),
    );
  }
}
