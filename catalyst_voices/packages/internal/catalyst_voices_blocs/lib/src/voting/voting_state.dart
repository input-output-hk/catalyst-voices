import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

final class VotingHeaderData extends Equatable {
  final bool showCategoryPicker;
  final CampaignCategoryDetailsViewModel? category;

  const VotingHeaderData({
    this.showCategoryPicker = false,
    this.category,
  });

  @override
  List<Object?> get props => [showCategoryPicker, category];
}

/// The state of available proposals in the voting page.
class VotingState extends Equatable {
  final CampaignCategoryDetailsViewModel? selectedCategory;
  final int? fundNumber;
  final VotingPowerViewModel votingPower;
  final VotingPhaseProgressDetailsViewModel? votingPhase;
  final bool hasSearchQuery;
  final List<String> favoritesIds;
  final ProposalsCount count;
  final List<ProposalsCategorySelectorItem> categorySelectorItems;

  const VotingState({
    this.selectedCategory,
    this.fundNumber,
    this.votingPower = const VotingPowerViewModel(),
    this.votingPhase,
    this.hasSearchQuery = false,
    this.favoritesIds = const [],
    this.count = const ProposalsCount(),
    this.categorySelectorItems = const [],
  });

  VotingHeaderData get header {
    return VotingHeaderData(
      showCategoryPicker: votingPhase?.status.isActive ?? false,
      category: selectedCategory,
    );
  }

  @override
  List<Object?> get props => [
    selectedCategory,
    fundNumber,
    votingPower,
    votingPhase,
    hasSearchQuery,
    favoritesIds,
    count,
    categorySelectorItems,
  ];

  SignedDocumentRef? get selectedCategoryRef {
    return categorySelectorItems.singleWhereOrNull((element) => element.isSelected)?.ref;
  }

  VotingState copyWith({
    Optional<CampaignCategoryDetailsViewModel>? selectedCategory,
    Optional<int>? fundNumber,
    VotingPowerViewModel? votingPower,
    Optional<VotingPhaseProgressDetailsViewModel>? votingPhase,
    bool? hasSearchQuery,
    List<String>? favoritesIds,
    ProposalsCount? count,
    List<ProposalsCategorySelectorItem>? categorySelectorItems,
  }) {
    return VotingState(
      selectedCategory: selectedCategory.dataOr(this.selectedCategory),
      fundNumber: fundNumber.dataOr(this.fundNumber),
      votingPower: votingPower ?? this.votingPower,
      votingPhase: votingPhase.dataOr(this.votingPhase),
      hasSearchQuery: hasSearchQuery ?? this.hasSearchQuery,
      favoritesIds: favoritesIds ?? this.favoritesIds,
      count: count ?? this.count,
      categorySelectorItems: categorySelectorItems ?? this.categorySelectorItems,
    );
  }

  List<VotingPageTab> tabs({required bool isProposerUnlock}) {
    return VotingPageTab.values
        .where((tab) => tab != VotingPageTab.my || isProposerUnlock)
        .toList();
  }
}

final class VotingStateOrderDropdown extends Equatable {
  final List<ProposalsDropdownOrderItem> items;
  final bool isEnabled;

  const VotingStateOrderDropdown._({
    required this.items,
    required this.isEnabled,
  });

  @override
  List<Object?> get props => [items, isEnabled];

  ProposalsOrder? get selectedOrder {
    return items.singleWhereOrNull((element) => element.isSelected)?.value;
  }
}
