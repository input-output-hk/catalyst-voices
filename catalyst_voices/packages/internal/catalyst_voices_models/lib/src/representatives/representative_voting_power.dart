import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Represents the voting power of a representative.
final class RepresentativeVotingPower extends Equatable {
  /// The voting power held by the representative themselves.
  final VotingPower? own;

  /// The voting power delegated to the representative by others.
  final VotingPower? delegated;

  /// Creates a [RepresentativeVotingPower].
  const RepresentativeVotingPower({
    this.own,
    this.delegated,
  });

  @override
  List<Object?> get props => [own, delegated];

  VotingPowerStatus? get status {
    final ownStatus = own?.status;
    final delegatedStatus = delegated?.status;

    return switch ((ownStatus, delegatedStatus)) {
      (VotingPowerStatus.confirmed, VotingPowerStatus.confirmed) => VotingPowerStatus.confirmed,
      (null, null) => null,
      (_, _) => VotingPowerStatus.provisional,
    };
  }

  /// Total voting power amount.
  int get totalAmount => (own?.amount ?? 0) + (delegated?.amount ?? 0);

  /// Creates a copy of this instance with the given fields replaced with the new values.
  RepresentativeVotingPower copyWith({
    Optional<VotingPower>? own,
    Optional<VotingPower>? delegated,
  }) {
    return RepresentativeVotingPower(
      own: own.dataOr(this.own),
      delegated: delegated.dataOr(this.delegated),
    );
  }
}
