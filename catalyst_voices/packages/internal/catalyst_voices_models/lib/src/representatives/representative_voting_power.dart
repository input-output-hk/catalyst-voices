import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class RepresentativeVotingPower extends Equatable {
  final VotingPower? own;
  final VotingPower? delegated;

  const RepresentativeVotingPower({
    this.own,
    this.delegated,
  });

  @override
  List<Object?> get props => [own, delegated];

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
