import 'package:catalyst_voices_models/catalyst_voices_models.dart';

final class ChangeCategorySignal implements ProposalsSignal {
  final SignedDocumentRef? to;

  ChangeCategorySignal({
    this.to,
  });
}

sealed class ProposalsSignal {}
