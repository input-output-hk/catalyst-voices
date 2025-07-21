import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

/// The state of available proposals in the voting page.
class VotingState extends Equatable {
  final VotingPowerViewModel? votingPower;
  final VotingPhaseProgressViewModel? votingPhase;
  final bool hasSearchQuery;
  final List<String> favoritesIds;
  final ProposalsCount count;
  final List<ProposalsCategorySelectorItem> categorySelectorItems;
  final List<ProposalsDropdownOrderItem> orderItems;
  final bool isOrderEnabled;

  const VotingState({
    this.votingPower,
    this.votingPhase,
    this.hasSearchQuery = false,
    this.favoritesIds = const [],
    this.count = const ProposalsCount(),
    this.categorySelectorItems = const [],
    this.orderItems = const [],
    this.isOrderEnabled = false,
  });

  VotingStateOrderDropdown get orderDropdown {
    return VotingStateOrderDropdown._(items: orderItems, isEnabled: isOrderEnabled);
  }

  @override
  List<Object?> get props => [
        votingPower,
        votingPhase,
        hasSearchQuery,
        favoritesIds,
        count,
        categorySelectorItems,
        orderItems,
        isOrderEnabled,
      ];

  SignedDocumentRef? get selectedCategoryId {
    return categorySelectorItems.singleWhereOrNull((element) => element.isSelected)?.ref;
  }

  VotingState copyWith({
    Optional<VotingPowerViewModel>? votingPower,
    Optional<VotingPhaseProgressViewModel>? votingPhase,
    bool? hasSearchQuery,
    List<String>? favoritesIds,
    ProposalsCount? count,
    List<ProposalsCategorySelectorItem>? categorySelectorItems,
    List<ProposalsDropdownOrderItem>? orderItems,
    bool? isOrderEnabled,
  }) {
    return VotingState(
      votingPower: votingPower.dataOr(this.votingPower),
      votingPhase: votingPhase.dataOr(this.votingPhase),
      hasSearchQuery: hasSearchQuery ?? this.hasSearchQuery,
      favoritesIds: favoritesIds ?? this.favoritesIds,
      count: count ?? this.count,
      categorySelectorItems: categorySelectorItems ?? this.categorySelectorItems,
      orderItems: orderItems ?? this.orderItems,
      isOrderEnabled: isOrderEnabled ?? this.isOrderEnabled,
    );
  }

  bool isFavorite(String proposalId) => favoritesIds.contains(proposalId);
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
