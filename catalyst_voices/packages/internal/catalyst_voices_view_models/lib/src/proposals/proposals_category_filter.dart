import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalsAnyCategoryFilter extends ProposalsCategoryFilter {
  const ProposalsAnyCategoryFilter() : super(ref: null);
}

sealed class ProposalsCategoryFilter extends Equatable {
  final SignedDocumentRef? ref;

  const ProposalsCategoryFilter({
    this.ref,
  });

  @override
  List<Object?> get props => [ref];
}

final class ProposalsRefCategoryFilter extends ProposalsCategoryFilter {
  const ProposalsRefCategoryFilter({
    required SignedDocumentRef super.ref,
  });
}
