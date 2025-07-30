import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class ChangeCategoryProposalsSignal extends ProposalsSignal {
  final SignedDocumentRef? to;

  const ChangeCategoryProposalsSignal({
    this.to,
  });

  @override
  List<Object?> get props => [to];
}

final class ChangeFilterTypeProposalsSignal extends ProposalsSignal {
  final ProposalsFilterType type;

  const ChangeFilterTypeProposalsSignal(this.type);

  @override
  List<Object?> get props => [type];
}

final class PageReadyProposalsSignal extends ProposalsSignal {
  final Page<ProposalBrief> page;

  const PageReadyProposalsSignal({required this.page});

  @override
  List<Object?> get props => [page];
}

sealed class ProposalsSignal extends Equatable {
  const ProposalsSignal();
}

final class ResetPaginationProposalsSignal extends ProposalsSignal {
  const ResetPaginationProposalsSignal();

  @override
  List<Object?> get props => [];
}
