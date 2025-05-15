import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

/// The state of available proposals.
class ProposalsState extends Equatable {
  final bool hasSearchQuery;
  final List<String> favoritesIds;
  final ProposalsCount count;
  final List<ProposalsCategorySelectorItem> categorySelectorItems;

  const ProposalsState({
    this.hasSearchQuery = false,
    this.favoritesIds = const [],
    this.count = const ProposalsCount(),
    this.categorySelectorItems = const [],
  });

  @override
  List<Object?> get props => [
        hasSearchQuery,
        favoritesIds,
        count,
        categorySelectorItems,
      ];

  SignedDocumentRef? get selectedCategoryId => categorySelectorItems
      .firstWhereOrNull((element) => element.isSelected)
      ?.ref;

  ProposalsState copyWith({
    bool? hasSearchQuery,
    List<String>? favoritesIds,
    ProposalsCount? count,
    List<ProposalsCategorySelectorItem>? categorySelectorItems,
  }) {
    return ProposalsState(
      hasSearchQuery: hasSearchQuery ?? this.hasSearchQuery,
      favoritesIds: favoritesIds ?? this.favoritesIds,
      count: count ?? this.count,
      categorySelectorItems:
          categorySelectorItems ?? this.categorySelectorItems,
    );
  }

  bool isFavorite(String proposalId) => favoritesIds.contains(proposalId);
}
