import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalsCubitCache extends Equatable {
  final bool? onlyMy;
  final SignedDocumentRef? selectedCategory;
  final List<CampaignCategory>? categories;

  const ProposalsCubitCache({
    this.onlyMy,
    this.selectedCategory,
    this.categories,
  });

  @override
  List<Object?> get props => [
        onlyMy,
        selectedCategory,
        categories,
      ];

  ProposalsCubitCache copyWith({
    Optional<bool>? onlyMy,
    Optional<SignedDocumentRef>? selectedCategory,
    Optional<List<CampaignCategory>>? categories,
  }) {
    return ProposalsCubitCache(
      onlyMy: onlyMy.dataOr(this.onlyMy),
      selectedCategory: selectedCategory.dataOr(this.selectedCategory),
      categories: categories.dataOr(this.categories),
    );
  }
}
