import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalsCubitCache extends Equatable {
  final SignedDocumentRef? selectedCategory;
  final List<CampaignCategory>? categories;

  const ProposalsCubitCache({
    this.selectedCategory,
    this.categories,
  });

  @override
  List<Object?> get props => [
        selectedCategory,
        categories,
      ];

  ProposalsCubitCache copyWith({
    Optional<SignedDocumentRef>? selectedCategory,
    Optional<List<CampaignCategory>>? categories,
  }) {
    return ProposalsCubitCache(
      selectedCategory: selectedCategory.dataOr(this.selectedCategory),
      categories: categories.dataOr(this.categories),
    );
  }
}
