import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class VotingBallot extends Equatable {
  final List<Vote> votes;

  const VotingBallot({
    required this.votes,
  });

  @override
  List<Object?> get props => [
    votes,
  ];
}
