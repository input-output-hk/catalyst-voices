import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Category filter for proposals with any category
final class ProposalsAnyCategoryFilter extends ProposalsCategoryFilter {
  const ProposalsAnyCategoryFilter() : super(ref: null);
}

/// Category filter for proposals
sealed class ProposalsCategoryFilter extends Equatable {
  final SignedDocumentRef? ref;

  const ProposalsCategoryFilter({
    this.ref,
  });

  @override
  List<Object?> get props => [ref];
}

/// Category filter for proposals by a specific category
final class ProposalsRefCategoryFilter extends ProposalsCategoryFilter {
  const ProposalsRefCategoryFilter({
    required SignedDocumentRef super.ref,
  });
}
