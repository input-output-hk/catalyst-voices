import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// A set of filters to be applied when querying for proposals.
base class ProposalsFiltersV2 extends Equatable {
  /// Filters proposals by their effective status. If null, this filter is not applied.
  final ProposalStatusFilter? status;

  /// Filters proposals based on whether they are marked as a favorite.
  /// If null, this filter is not applied.
  final bool? isFavorite;

  /// Filters proposals by specific relationships (Author, Collaborator, etc.).
  ///
  /// If multiple relationships are provided, they are treated as an OR condition.
  /// Example: {OriginalAuthor(A), CollaborationInvitation.accepted(A)} finds documents
  /// where A is EITHER the author OR has accepted collaboration.
  final Set<ProposalsRelationship> relationships;

  /// Filters proposals by their category ID.
  /// If null, this filter is not applied.
  final String? categoryId;

  /// A search term to match against proposal titles or author names.
  /// If null, no text search is performed.
  final String? searchQuery;

  /// Filters proposals to only include those created within the [latestUpdate] duration
  /// from the current time.
  /// If null, this filter is not applied.
  final Duration? latestUpdate;

  /// Filters proposals based on their campaign categories.
  /// If [campaign] is not null and [categoryId] is not included, empty list will be returned.
  /// If null, this filter is not applied.
  final CampaignFilters? campaign;

  /// Filters proposals based on whether a specific user has voted on them.
  /// The value is the [CatalystId] of the user.
  /// If null, this filter is not applied.
  final CatalystId? voteBy;

  // TODO(damian-molinski): Remove this when voteBy is implemented
  /// Temporary filter only for mocked implementation of [voteBy].
  final List<String>? ids;

  /// Creates a set of filters for querying proposals.
  const ProposalsFiltersV2({
    this.status,
    this.isFavorite,
    this.relationships = const {},
    this.categoryId,
    this.searchQuery,
    this.latestUpdate,
    this.campaign,
    this.voteBy,
    this.ids,
  });

  @override
  List<Object?> get props => [
    status,
    isFavorite,
    relationships,
    categoryId,
    searchQuery,
    latestUpdate,
    campaign,
    voteBy,
    ids,
  ];

  ProposalsFiltersV2 copyWith({
    Optional<ProposalStatusFilter>? status,
    Optional<bool>? isFavorite,
    Set<ProposalsRelationship>? relationships,
    Optional<String>? categoryId,
    Optional<String>? searchQuery,
    Optional<Duration>? latestUpdate,
    Optional<CampaignFilters>? campaign,
    Optional<CatalystId>? voteBy,
    Optional<List<String>>? ids,
  }) {
    return ProposalsFiltersV2(
      status: status.dataOr(this.status),
      isFavorite: isFavorite.dataOr(this.isFavorite),
      relationships: relationships ?? this.relationships,
      categoryId: categoryId.dataOr(this.categoryId),
      searchQuery: searchQuery.dataOr(this.searchQuery),
      latestUpdate: latestUpdate.dataOr(this.latestUpdate),
      campaign: campaign.dataOr(this.campaign),
      voteBy: voteBy.dataOr(this.voteBy),
      ids: ids.dataOr(this.ids),
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer('ProposalsFiltersV2(');
    final parts = <String>[];

    if (status != null) {
      parts.add('status: $status');
    }
    if (isFavorite != null) {
      parts.add('isFavorite: $isFavorite');
    }
    if (relationships.isNotEmpty) {
      parts.add('relationships: (${relationships.map((e) => e.toString()).join(' OR ')})');
    }
    if (categoryId != null) {
      parts.add('categoryId: $categoryId');
    }
    if (searchQuery != null) {
      parts.add('searchQuery: "$searchQuery"');
    }
    if (latestUpdate != null) {
      parts.add('latestUpdate: $latestUpdate');
    }
    if (campaign != null) {
      parts.add('campaign: $campaign');
    }
    if (voteBy != null) {
      parts.add('votedBy: $voteBy');
    }
    if (ids != null) {
      parts.add('ids: ${ids!.join(',')}');
    }

    buffer
      ..write(parts.isNotEmpty ? parts.join(', ') : 'no filters')
      ..write(')');

    return buffer.toString();
  }
}

/// An enum representing the status of a proposal for filtering purposes.
enum ProposalStatusFilter {
  /// Represents a final, submitted proposal.
  aFinal,

  /// Represents a proposal that is still in draft state.
  draft,
}
