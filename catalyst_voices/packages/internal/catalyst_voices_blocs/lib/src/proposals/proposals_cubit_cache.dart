import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalsCubitCache extends Equatable {
  final bool? onlyMy;
  final SignedDocumentRef? selectedCategory;
  final ProposalsFilterType? type;
  final List<CampaignCategory>? categories;

  const ProposalsCubitCache({
    this.onlyMy,
    this.selectedCategory,
    this.type,
    this.categories,
  });

  @override
  List<Object?> get props => [
        onlyMy,
        selectedCategory,
        type,
        categories,
      ];

  ProposalsCubitCache copyWith({
    Optional<bool>? onlyMy,
    Optional<SignedDocumentRef>? selectedCategory,
    Optional<ProposalsFilterType>? type,
    Optional<List<CampaignCategory>>? categories,
  }) {
    return ProposalsCubitCache(
      onlyMy: onlyMy.dataOr(this.onlyMy),
      selectedCategory: selectedCategory.dataOr(this.selectedCategory),
      type: type.dataOr(this.type),
      categories: categories.dataOr(this.categories),
    );
  }
}
