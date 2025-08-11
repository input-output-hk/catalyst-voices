import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalViewVoting extends Equatable {
  final VoteButtonData voteButtonData;
  final DocumentRef proposalRef;

  const ProposalViewVoting(this.voteButtonData, this.proposalRef);

  @override
  List<Object?> get props => [voteButtonData];
}
