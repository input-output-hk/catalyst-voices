import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

class ProposalVotes extends Equatable {
  final DocumentRef proposalRef;
  final Vote? currentDraft;
  final Vote? lastCasted;

  const ProposalVotes({
    required this.proposalRef,
    this.currentDraft,
    this.lastCasted,
  });

  @override
  List<Object?> get props => [
        proposalRef,
        currentDraft,
        lastCasted,
      ];

  ProposalVotes copyWith({
    DocumentRef? proposalRef,
    Optional<Vote>? currentDraft,
    Optional<Vote>? lastCasted,
  }) {
    return ProposalVotes(
      proposalRef: proposalRef ?? this.proposalRef,
      currentDraft: currentDraft.dataOr(this.currentDraft),
      lastCasted: lastCasted.dataOr(this.lastCasted),
    );
  }
}
