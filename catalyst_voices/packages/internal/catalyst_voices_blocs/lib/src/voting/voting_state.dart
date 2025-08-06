import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

/// The state of available proposals in the voting page.
class VotingState extends Equatable {
  final CampaignCategoryDetailsViewModel? selectedCategory;
  final int? fundNumber;
  final VotingPowerViewModel votingPower;
  final VotingPhaseProgressViewModel votingPhase;
  final bool hasSearchQuery;
  final List<String> favoritesIds;
  final List<ProposalVotes> proposalVotes;
  final ProposalsCount count;
  final List<ProposalsCategorySelectorItem> categorySelectorItems;

  const VotingState({
    this.selectedCategory,
    this.fundNumber,
    this.votingPower = const VotingPowerViewModel(),
    this.votingPhase = const VotingPhaseProgressViewModel(),
    this.hasSearchQuery = false,
    this.favoritesIds = const [],
    this.proposalVotes = const [],
    this.count = const ProposalsCount(),
    this.categorySelectorItems = const [],
  });

  @override
  List<Object?> get props => [
        selectedCategory,
        fundNumber,
        votingPower,
        votingPhase,
        hasSearchQuery,
        favoritesIds,
        proposalVotes,
        count,
        categorySelectorItems,
      ];

  SignedDocumentRef? get selectedCategoryId {
    return categorySelectorItems.singleWhereOrNull((element) => element.isSelected)?.ref;
  }

  VotingState copyWith({
    Optional<CampaignCategoryDetailsViewModel>? selectedCategory,
    Optional<int>? fundNumber,
    VotingPowerViewModel? votingPower,
    VotingPhaseProgressViewModel? votingPhase,
    bool? hasSearchQuery,
    List<String>? favoritesIds,
    List<ProposalVotes>? proposalVotes,
    ProposalsCount? count,
    List<ProposalsCategorySelectorItem>? categorySelectorItems,
  }) {
    return VotingState(
      selectedCategory: selectedCategory.dataOr(this.selectedCategory),
      fundNumber: fundNumber.dataOr(this.fundNumber),
      votingPower: votingPower ?? this.votingPower,
      votingPhase: votingPhase ?? this.votingPhase,
      hasSearchQuery: hasSearchQuery ?? this.hasSearchQuery,
      favoritesIds: favoritesIds ?? this.favoritesIds,
      proposalVotes: proposalVotes ?? this.proposalVotes,
      count: count ?? this.count,
      categorySelectorItems: categorySelectorItems ?? this.categorySelectorItems,
    );
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
