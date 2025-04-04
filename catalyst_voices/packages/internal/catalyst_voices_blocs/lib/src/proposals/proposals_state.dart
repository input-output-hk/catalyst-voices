import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

/// The state of available proposals.
class ProposalsState extends Equatable {
  final ProposalPaginationItems<ProposalViewModel> proposals;
  final List<String> favoritesIds;
  final List<String> myProposalsIds;
  final String? searchValue;
  final ProposalsTypeCount count;
  final List<ProposalsCategorySelectorItem> categorySelectorItems;

  const ProposalsState({
    this.proposals = const ProposalPaginationItems(),
    this.favoritesIds = const [],
    this.myProposalsIds = const [],
    this.searchValue,
    this.count = const ProposalsTypeCount(),
    this.categorySelectorItems = const [],
  });

  @override
  List<Object?> get props => [
        proposals,
        favoritesIds,
        myProposalsIds,
        searchValue,
        count,
        categorySelectorItems,
      ];

  SignedDocumentRef? get selectedCategoryId => categorySelectorItems
      .firstWhereOrNull((element) => element.isSelected)
      ?.ref;

  ProposalsState copyWith({
    ProposalPaginationItems<ProposalViewModel>? proposals,
    List<String>? favoritesIds,
    List<String>? myProposalsIds,
    List<CampaignCategoryDetailsViewModel>? categories,
    Optional<SignedDocumentRef>? selectedCategoryId,
    Optional<String>? searchValue,
    ProposalsTypeCount? count,
    List<ProposalsCategorySelectorItem>? categorySelectorItems,
  }) {
    return ProposalsState(
      proposals: proposals ?? this.proposals,
      favoritesIds: favoritesIds ?? this.favoritesIds,
      myProposalsIds: myProposalsIds ?? this.myProposalsIds,
      searchValue: searchValue.dataOr(this.searchValue),
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
