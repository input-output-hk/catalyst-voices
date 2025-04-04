import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';

final class ChangeCategorySignal implements ProposalsSignal {
  final SignedDocumentRef? to;

  ChangeCategorySignal({
    this.to,
  });
}

sealed class ProposalsSignal {}

final class ChangeFilterType implements ProposalsSignal {
  final ProposalsFilterType type;

  ChangeFilterType(this.type);
}
