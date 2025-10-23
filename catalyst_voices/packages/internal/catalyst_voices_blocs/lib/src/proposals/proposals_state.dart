import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

final class ProposalsCategoryState extends Equatable {
  final List<ProposalsCategorySelectorItem> items;

  const ProposalsCategoryState([this.items = const []]);

  @override
  List<Object?> get props => [items];

  SignedDocumentRef? get selectedCategoryRef {
    return items.singleWhereOrNull((element) => element.isSelected)?.ref;
  }
}

final class ProposalsOrderState extends Equatable {
  final List<ProposalsDropdownOrderItem> items;

  const ProposalsOrderState([this.items = const []]);

  @override
  List<Object?> get props => [items];
}

/// The state of available proposals.
class ProposalsState extends Equatable {
  final bool hasSearchQuery;
  final List<String> favoritesIds;
  final ProposalsCount count;
  final ProposalsCategoryState category;
  final Duration recentProposalsMaxAge;
  final bool isRecentProposalsEnabled;
  final ProposalsOrderState order;
  final bool isOrderEnabled;

  const ProposalsState({
    this.hasSearchQuery = false,
    this.favoritesIds = const [],
    this.count = const ProposalsCount(),
    this.category = const ProposalsCategoryState(),
    required this.recentProposalsMaxAge,
    this.isRecentProposalsEnabled = false,
    this.order = const ProposalsOrderState(),
    this.isOrderEnabled = false,
  });

  ProposalsStateLatestUpdateCheckbox get latestUpdatedCheckbox {
    return ProposalsStateLatestUpdateCheckbox._(
      maxAge: recentProposalsMaxAge,
      isEnabled: isRecentProposalsEnabled,
    );
  }

  ProposalsStateOrderDropdown get orderDropdown {
    return ProposalsStateOrderDropdown._(items: order.items, isEnabled: isOrderEnabled);
  }

  @override
  List<Object?> get props => [
    hasSearchQuery,
    favoritesIds,
    count,
    category,
    recentProposalsMaxAge,
    isRecentProposalsEnabled,
    order,
    isOrderEnabled,
  ];

  ProposalsState copyWith({
    bool? hasSearchQuery,
    List<String>? favoritesIds,
    ProposalsCount? count,
    ProposalsCategoryState? category,
    Duration? recentProposalsMaxAge,
    bool? isRecentProposalsEnabled,
    ProposalsOrderState? order,
    bool? isOrderEnabled,
  }) {
    return ProposalsState(
      hasSearchQuery: hasSearchQuery ?? this.hasSearchQuery,
      favoritesIds: favoritesIds ?? this.favoritesIds,
      count: count ?? this.count,
      category: category ?? this.category,
      recentProposalsMaxAge: recentProposalsMaxAge ?? this.recentProposalsMaxAge,
      isRecentProposalsEnabled: isRecentProposalsEnabled ?? this.isRecentProposalsEnabled,
      order: order ?? this.order,
      isOrderEnabled: isOrderEnabled ?? this.isOrderEnabled,
    );
  }

  bool isFavorite(String proposalId) => favoritesIds.contains(proposalId);

  List<ProposalsPageTab> tabs({required bool isProposerUnlock}) {
    return ProposalsPageTab.values
        .where((tab) => tab != ProposalsPageTab.my || isProposerUnlock)
        .toList();
  }
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
