import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
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
  final List<CampaignCategoryViewModel> categories;
  final String? selectedCategoryId;
  final String? searchValue;

  const ProposalsState({
    this.draftProposals = const ProposalPaginationItems(),
    this.finalProposals = const ProposalPaginationItems(),
    this.favoriteProposals = const ProposalPaginationItems(),
    this.userProposals = const ProposalPaginationItems(),
    this.allProposals = const ProposalPaginationItems(),
    this.favoritesIds = const [],
    this.myProposalsIds = const [],
    this.categories = const [],
    this.selectedCategoryId,
    this.searchValue,
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
        categories,
        selectedCategoryId,
        searchValue,
      ];

  ProposalsState copyWith({
    ProposalPaginationItems<ProposalViewModel>? draftProposals,
    ProposalPaginationItems<ProposalViewModel>? finalProposals,
    ProposalPaginationItems<ProposalViewModel>? favoriteProposals,
    ProposalPaginationItems<ProposalViewModel>? userProposals,
    ProposalPaginationItems<ProposalViewModel>? allProposals,
    List<String>? favoritesIds,
    List<String>? myProposalsIds,
    List<CampaignCategoryViewModel>? categories,
    Optional<String>? selectedCategoryId,
    Optional<String>? searchValue,
    bool isLoading = false,
  }) {
    return ProposalsState(
      draftProposals: draftProposals ?? this.draftProposals,
      finalProposals: finalProposals ?? this.finalProposals,
      favoriteProposals: favoriteProposals ?? this.favoriteProposals,
      userProposals: userProposals ?? this.userProposals,
      allProposals: allProposals ?? this.allProposals,
      favoritesIds: favoritesIds ?? this.favoritesIds,
      myProposalsIds: myProposalsIds ?? this.myProposalsIds,
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId.dataOr(this.selectedCategoryId),
      searchValue: searchValue.dataOr(this.searchValue),
    );
  }

  bool isFavorite(String proposalId) {
    return favoriteProposals.items.any((e) => e.id == proposalId);
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
