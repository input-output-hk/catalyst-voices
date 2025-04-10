import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class ChangeCategorySignal extends ProposalsSignal {
  final SignedDocumentRef? to;

  const ChangeCategorySignal({
    this.to,
  });

  @override
  List<Object?> get props => [to];
}

final class ChangeFilterTypeSignal extends ProposalsSignal {
  final ProposalsFilterType type;

  const ChangeFilterTypeSignal(this.type);

  @override
  List<Object?> get props => [type];
}

final class ProposalsPageReadySignal extends ProposalsSignal {
  final Page<ProposalViewModel> page;

  const ProposalsPageReadySignal({required this.page});

  @override
  List<Object?> get props => [page];
}

sealed class ProposalsSignal extends Equatable {
  const ProposalsSignal();
}

final class ResetProposalsPaginationSignal extends ProposalsSignal {
  const ResetProposalsPaginationSignal();

  @override
  List<Object?> get props => [];
}
