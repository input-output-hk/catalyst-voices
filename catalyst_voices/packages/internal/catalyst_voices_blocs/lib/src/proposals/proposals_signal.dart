import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';

final class ChangeCategorySignal implements ProposalsSignal {
  final SignedDocumentRef? to;

  const ChangeCategorySignal({
    this.to,
  });
}

final class ChangeFilterTypeSignal implements ProposalsSignal {
  final ProposalsFilterType type;

  const ChangeFilterTypeSignal(this.type);
}

final class ProposalsPageReadySignal implements ProposalsSignal {
  final Page<ProposalViewModel> page;

  const ProposalsPageReadySignal({required this.page});
}

sealed class ProposalsSignal {}

final class ResetProposalsPaginationSignal implements ProposalsSignal {
  const ResetProposalsPaginationSignal();
}
