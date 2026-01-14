import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

final class ProposalsCategoryState extends Equatable {
  final List<ProposalsCategorySelectorItem> items;

  const ProposalsCategoryState([this.items = const []]);

  @override
  List<Object?> get props => [items];

  SignedDocumentRef? get selectedCategoryId {
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
  final Map<ProposalsPageTab, int> count;
  final ProposalsCategoryState category;
  final Duration recentProposalsMaxAge;
  final bool isRecentProposalsEnabled;
  final ProposalsOrderState order;
  final bool isOrderEnabled;

  const ProposalsState({
    this.hasSearchQuery = false,
    this.count = const {},
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
    count,
    category,
    recentProposalsMaxAge,
    isRecentProposalsEnabled,
    order,
    isOrderEnabled,
  ];

  ProposalsState copyWith({
    bool? hasSearchQuery,
    Map<ProposalsPageTab, int>? count,
    ProposalsCategoryState? category,
    Duration? recentProposalsMaxAge,
    bool? isRecentProposalsEnabled,
    ProposalsOrderState? order,
    bool? isOrderEnabled,
  }) {
    return ProposalsState(
      hasSearchQuery: hasSearchQuery ?? this.hasSearchQuery,
      count: count ?? this.count,
      category: category ?? this.category,
      recentProposalsMaxAge: recentProposalsMaxAge ?? this.recentProposalsMaxAge,
      isRecentProposalsEnabled: isRecentProposalsEnabled ?? this.isRecentProposalsEnabled,
      order: order ?? this.order,
      isOrderEnabled: isOrderEnabled ?? this.isOrderEnabled,
    );
  }

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
