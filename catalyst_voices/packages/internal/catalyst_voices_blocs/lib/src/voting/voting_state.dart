import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

final class VotingHeaderCategoryData extends Equatable {
  final String formattedName;
  final String description;
  final String imageUrl;

  const VotingHeaderCategoryData({
    required this.formattedName,
    required this.description,
    required this.imageUrl,
  });

  VotingHeaderCategoryData.fromModel(CampaignCategory data)
    : this(
        formattedName: data.formattedCategoryName,
        description: data.description,
        imageUrl: data.imageUrl,
      );

  @override
  List<Object?> get props => [
    formattedName,
    description,
    imageUrl,
  ];
}

/// The state of available proposals in the voting page.
class VotingState extends Equatable {
  final VotingHeaderCategoryData? selectedCategoryHeaderData;
  final int? fundNumber;
  final VotingRoleViewModel votingRole;
  final VotingPhaseProgressDetailsViewModel? votingPhase;
  final VotingTimelineDetailsViewModel? votingTimeline;
  final bool hasSearchQuery;
  final bool isDelegator;
  final bool isVotingResultsOrTallyActive;
  final Map<VotingPageTab, int> count;
  final List<ProposalsCategorySelectorItem> categorySelectorItems;

  const VotingState({
    this.selectedCategoryHeaderData,
    this.fundNumber,
    this.votingRole = const EmptyVotingRoleViewModel(),
    this.votingPhase,
    this.votingTimeline,
    this.hasSearchQuery = false,
    this.isDelegator = false,
    this.isVotingResultsOrTallyActive = false,
    this.count = const {},
    this.categorySelectorItems = const [],
  });

  bool get hasSelectedCategory => categorySelectorItems.any((element) => element.isSelected);

  @override
  List<Object?> get props => [
    selectedCategoryHeaderData,
    fundNumber,
    votingRole,
    votingPhase,
    votingTimeline,
    hasSearchQuery,
    isDelegator,
    isVotingResultsOrTallyActive,
    count,
    categorySelectorItems,
  ];

  SignedDocumentRef? get selectedCategoryId {
    return categorySelectorItems.singleWhereOrNull((element) => element.isSelected)?.ref;
  }

  VotingState copyWith({
    Optional<VotingHeaderCategoryData>? selectedCategoryHeaderData,
    Optional<int>? fundNumber,
    VotingRoleViewModel? votingRole,
    Optional<VotingPhaseProgressDetailsViewModel>? votingPhase,
    Optional<VotingTimelineDetailsViewModel>? votingTimeline,
    bool? hasSearchQuery,
    bool? isDelegator,
    bool? isVotingResultsOrTallyActive,
    Map<VotingPageTab, int>? count,
    List<ProposalsCategorySelectorItem>? categorySelectorItems,
  }) {
    return VotingState(
      selectedCategoryHeaderData: selectedCategoryHeaderData.dataOr(
        this.selectedCategoryHeaderData,
      ),
      fundNumber: fundNumber.dataOr(this.fundNumber),
      votingRole: votingRole ?? this.votingRole,
      votingPhase: votingPhase.dataOr(this.votingPhase),
      votingTimeline: votingTimeline.dataOr(this.votingTimeline),
      hasSearchQuery: hasSearchQuery ?? this.hasSearchQuery,
      isDelegator: isDelegator ?? this.isDelegator,
      isVotingResultsOrTallyActive:
          isVotingResultsOrTallyActive ?? this.isVotingResultsOrTallyActive,
      count: count ?? this.count,
      categorySelectorItems: categorySelectorItems ?? this.categorySelectorItems,
    );
  }

  List<VotingPageTab> tabs({required bool isProposerUnlock}) {
    return [
      if (isVotingResultsOrTallyActive) VotingPageTab.results,
      if (!isVotingResultsOrTallyActive) VotingPageTab.total,
      if (isProposerUnlock) VotingPageTab.myFinalProposals,
      VotingPageTab.favorites,
      if (!isDelegator) VotingPageTab.myVotes,
    ];
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
