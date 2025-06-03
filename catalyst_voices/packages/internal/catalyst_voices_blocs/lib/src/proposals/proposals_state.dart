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
  final Duration recentProposalsMaxAge;
  final bool isRecentProposalsEnabled;
  final List<ProposalsDropdownOrderItem> orderItems;
  final bool isOrderEnabled;

  const ProposalsState({
    this.hasSearchQuery = false,
    this.favoritesIds = const [],
    this.count = const ProposalsCount(),
    this.categorySelectorItems = const [],
    required this.recentProposalsMaxAge,
    this.isRecentProposalsEnabled = false,
    this.orderItems = const [],
    this.isOrderEnabled = false,
  });

  ProposalsStateLatestUpdateCheckbox get latestUpdatedCheckbox {
    return ProposalsStateLatestUpdateCheckbox._(
      maxAge: recentProposalsMaxAge,
      isEnabled: isRecentProposalsEnabled,
    );
  }

  ProposalsStateOrderDropdown get orderDropdown {
    return ProposalsStateOrderDropdown._(items: orderItems, isEnabled: isOrderEnabled);
  }

  @override
  List<Object?> get props => [
        hasSearchQuery,
        favoritesIds,
        count,
        categorySelectorItems,
        recentProposalsMaxAge,
        isRecentProposalsEnabled,
        orderItems,
        isOrderEnabled,
      ];

  SignedDocumentRef? get selectedCategoryId {
    return categorySelectorItems.singleWhereOrNull((element) => element.isSelected)?.ref;
  }

  ProposalsState copyWith({
    bool? hasSearchQuery,
    List<String>? favoritesIds,
    ProposalsCount? count,
    List<ProposalsCategorySelectorItem>? categorySelectorItems,
    Duration? recentProposalsMaxAge,
    bool? isRecentProposalsEnabled,
    List<ProposalsDropdownOrderItem>? orderItems,
    bool? isOrderEnabled,
  }) {
    return ProposalsState(
      hasSearchQuery: hasSearchQuery ?? this.hasSearchQuery,
      favoritesIds: favoritesIds ?? this.favoritesIds,
      count: count ?? this.count,
      categorySelectorItems: categorySelectorItems ?? this.categorySelectorItems,
      recentProposalsMaxAge: recentProposalsMaxAge ?? this.recentProposalsMaxAge,
      isRecentProposalsEnabled: isRecentProposalsEnabled ?? this.isRecentProposalsEnabled,
      orderItems: orderItems ?? this.orderItems,
      isOrderEnabled: isOrderEnabled ?? this.isOrderEnabled,
    );
  }

  bool isFavorite(String proposalId) => favoritesIds.contains(proposalId);
}

final class ProposalsStateLatestUpdateCheckbox extends Equatable {
  final Duration maxAge;
  final bool isEnabled;

  const ProposalsStateLatestUpdateCheckbox._({
    required this.maxAge,
    required this.isEnabled,
  });

  @override
  List<Object?> get props => [maxAge, isEnabled];
}

final class ProposalsStateOrderDropdown extends Equatable {
  final List<ProposalsDropdownOrderItem> items;
  final bool isEnabled;

  const ProposalsStateOrderDropdown._({
    required this.items,
    required this.isEnabled,
  });

  @override
  List<Object?> get props => [items, isEnabled];

  ProposalsOrder? get selectedOrder {
    return items.singleWhereOrNull((element) => element.isSelected)?.value;
  }
}
