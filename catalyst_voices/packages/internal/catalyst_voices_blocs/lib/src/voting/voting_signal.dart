import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class ChangeCategoryVotingSignal extends VotingSignal {
  final SignedDocumentRef? to;

  const ChangeCategoryVotingSignal({
    this.to,
  });

  @override
  List<Object?> get props => [to];
}

final class ChangeTabVotingSignal extends VotingSignal {
  final VotingPageTab tab;

  const ChangeTabVotingSignal(this.tab);

  @override
  List<Object?> get props => [tab];
}

final class PageReadyVotingSignal extends VotingSignal {
  final Page<ProposalBrief> page;

  const PageReadyVotingSignal({required this.page});

  @override
  List<Object?> get props => [page];
}

final class ResetPaginationVotingSignal extends VotingSignal {
  const ResetPaginationVotingSignal();

  @override
  List<Object?> get props => [];
}

sealed class VotingSignal extends Equatable {
  const VotingSignal();
}
