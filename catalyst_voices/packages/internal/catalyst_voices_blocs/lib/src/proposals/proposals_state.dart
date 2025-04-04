import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

/// The state of available proposals.
class ProposalsState extends Equatable {
  final ProposalPaginationItems<ProposalViewModel> draftProposals;
  final ProposalPaginationItems<ProposalViewModel> finalProposals;
  final ProposalPaginationItems<ProposalViewModel> favoriteProposals;
  final ProposalPaginationItems<ProposalViewModel> userProposals;
  final ProposalPaginationItems<ProposalViewModel> allProposals;
  final List<String> favoritesIds;
  final List<String> myProposalsIds;
  final String? searchValue;

  final ProposalsTypeCount count;
  final List<ProposalsStateCategorySelectorItem> categorySelectorItems;

  const ProposalsState({
    this.draftProposals = const ProposalPaginationItems(),
    this.finalProposals = const ProposalPaginationItems(),
    this.favoriteProposals = const ProposalPaginationItems(),
    this.userProposals = const ProposalPaginationItems(),
    this.allProposals = const ProposalPaginationItems(),
    this.favoritesIds = const [],
    this.myProposalsIds = const [],
    this.searchValue,
    this.count = const ProposalsTypeCount(),
    this.categorySelectorItems = const [],
  });

  @override
  List<Object?> get props => [
        draftProposals,
        finalProposals,
        favoriteProposals,
        userProposals,
        allProposals,
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
    ProposalPaginationItems<ProposalViewModel>? draftProposals,
    ProposalPaginationItems<ProposalViewModel>? finalProposals,
    ProposalPaginationItems<ProposalViewModel>? favoriteProposals,
    ProposalPaginationItems<ProposalViewModel>? userProposals,
    ProposalPaginationItems<ProposalViewModel>? allProposals,
    List<String>? favoritesIds,
    List<String>? myProposalsIds,
    List<CampaignCategoryDetailsViewModel>? categories,
    Optional<SignedDocumentRef>? selectedCategoryId,
    Optional<String>? searchValue,
    bool isLoading = false,
    ProposalsTypeCount? count,
    List<ProposalsStateCategorySelectorItem>? categorySelectorItems,
  }) {
    return ProposalsState(
      draftProposals: draftProposals ?? this.draftProposals,
      finalProposals: finalProposals ?? this.finalProposals,
      favoriteProposals: favoriteProposals ?? this.favoriteProposals,
      userProposals: userProposals ?? this.userProposals,
      allProposals: allProposals ?? this.allProposals,
      favoritesIds: favoritesIds ?? this.favoritesIds,
      myProposalsIds: myProposalsIds ?? this.myProposalsIds,
      searchValue: searchValue.dataOr(this.searchValue),
      count: count ?? this.count,
      categorySelectorItems:
          categorySelectorItems ?? this.categorySelectorItems,
    );
  }

  bool isFavorite(String proposalId) {
    return favoriteProposals.items.any((e) => e.ref.id == proposalId);
  }
}

final class ProposalsStateCategorySelectorItem extends Equatable {
  final SignedDocumentRef ref;
  final String name;
  final bool isSelected;

  const ProposalsStateCategorySelectorItem({
    required this.ref,
    required this.name,
    required this.isSelected,
  });

  @override
  List<Object?> get props => [ref, name, isSelected];

  ProposalsStateCategorySelectorItem copyWith({
    SignedDocumentRef? ref,
    String? name,
    bool? isSelected,
  }) {
    return ProposalsStateCategorySelectorItem(
      ref: ref ?? this.ref,
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

final class ProposalsTypeCount extends Equatable {
  final int total;
  final int drafts;
  final int finals;
  final int favorites;
  final int my;

  const ProposalsTypeCount({
    this.total = 0,
    this.drafts = 0,
    this.finals = 0,
    this.favorites = 0,
    this.my = 0,
  });

  @override
  List<Object?> get props => [
        total,
        drafts,
        finals,
        favorites,
        my,
      ];

  ProposalsTypeCount copyWith({
    int? total,
    int? drafts,
    int? finals,
    int? favorites,
    int? my,
  }) {
    return ProposalsTypeCount(
      total: total ?? this.total,
      drafts: drafts ?? this.drafts,
      finals: finals ?? this.finals,
      my: my ?? this.my,
    );
  }
}

extension ProposalsStateLoading on ProposalsState {
  ProposalsState get allProposalsLoading =>
      copyWith(allProposals: allProposals.copyWith(isLoading: true));

  ProposalsState get draftProposalsLoading =>
      copyWith(draftProposals: draftProposals.copyWith(isLoading: true));

  ProposalsState get favoriteProposalsLoading =>
      copyWith(favoriteProposals: favoriteProposals.copyWith(isLoading: true));

  ProposalsState get finalProposalsLoading =>
      copyWith(finalProposals: finalProposals.copyWith(isLoading: true));

  ProposalsState get userProposalsLoading =>
      copyWith(userProposals: userProposals.copyWith(isLoading: true));
}
