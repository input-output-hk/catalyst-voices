import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class CategoryDetailCubitCache extends Equatable {
  final Campaign? activeCampaign;
  final List<CampaignCategory>? categories;
  final SignedDocumentRef? selectedCategoryRef;
  final CampaignCategory? selectedCategory;
  final CampaignCategoryTotalAsk? selectedCategoryTotalAsk;
  final DateTime? submissionCloseAt;

  const CategoryDetailCubitCache({
    this.activeCampaign,
    this.categories,
    this.selectedCategoryRef,
    this.selectedCategory,
    this.selectedCategoryTotalAsk,
    this.submissionCloseAt,
  });

  @override
  List<Object?> get props => [
    activeCampaign,
    categories,
    selectedCategoryRef,
    selectedCategory,
    selectedCategoryTotalAsk,
    submissionCloseAt,
  ];

  CategoryDetailCubitCache copyWith({
    Optional<Campaign>? activeCampaign,
    Optional<List<CampaignCategory>>? categories,
    Optional<SignedDocumentRef>? selectedCategoryRef,
    Optional<CampaignCategory>? selectedCategory,
    Optional<CampaignCategoryTotalAsk>? selectedCategoryTotalAsk,
    Optional<DateTime>? submissionCloseAt,
  }) {
    return CategoryDetailCubitCache(
      activeCampaign: activeCampaign.dataOr(this.activeCampaign),
      categories: categories.dataOr(this.categories),
      selectedCategoryRef: selectedCategoryRef.dataOr(this.selectedCategoryRef),
      selectedCategory: selectedCategory.dataOr(this.selectedCategory),
      selectedCategoryTotalAsk: selectedCategoryTotalAsk.dataOr(this.selectedCategoryTotalAsk),
      submissionCloseAt: submissionCloseAt.dataOr(this.submissionCloseAt),
    );
  }
}
