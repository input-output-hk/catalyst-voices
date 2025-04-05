import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

/// The state of available proposals.
class ProposalsState extends Equatable {
  final ProposalPaginationItems<ProposalViewModel> proposals;
  final bool hasSearchQuery;
  final List<String> favoritesIds;
  final ProposalsTypeCount count;
  final List<ProposalsCategorySelectorItem> categorySelectorItems;

  const ProposalsState({
    this.proposals = const ProposalPaginationItems(),
    this.hasSearchQuery = false,
    this.favoritesIds = const [],
    this.count = const ProposalsTypeCount(),
    this.categorySelectorItems = const [],
  });

  @override
  List<Object?> get props => [
        proposals,
        hasSearchQuery,
        favoritesIds,
        count,
        categorySelectorItems,
      ];

  SignedDocumentRef? get selectedCategoryId => categorySelectorItems
      .firstWhereOrNull((element) => element.isSelected)
      ?.ref;

  ProposalsState copyWith({
    ProposalPaginationItems<ProposalViewModel>? proposals,
    bool? hasSearchQuery,
    List<String>? favoritesIds,
    ProposalsTypeCount? count,
    List<ProposalsCategorySelectorItem>? categorySelectorItems,
  }) {
    return ProposalsState(
      proposals: proposals ?? this.proposals,
      hasSearchQuery: hasSearchQuery ?? this.hasSearchQuery,
      favoritesIds: favoritesIds ?? this.favoritesIds,
      count: count ?? this.count,
      categorySelectorItems:
          categorySelectorItems ?? this.categorySelectorItems,
    );
  }

  ProposalsState copyWithLoadingProposals({
    required bool isLoading,
  }) {
    return copyWith(proposals: proposals.copyWith(isLoading: isLoading));
  }

  bool isFavorite(String proposalId) => favoritesIds.contains(proposalId);
}
