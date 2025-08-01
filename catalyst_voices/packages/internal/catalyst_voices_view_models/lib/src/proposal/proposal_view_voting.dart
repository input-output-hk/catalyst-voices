import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalViewVoting extends Equatable {
  final VoteButtonData voteButtonData;

  const ProposalViewVoting(this.voteButtonData);

  @override
  List<Object?> get props => [voteButtonData];
}
