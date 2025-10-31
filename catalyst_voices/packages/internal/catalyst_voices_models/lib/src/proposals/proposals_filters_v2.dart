import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// A set of filters to be applied when querying for proposals.
final class ProposalsFiltersV2 extends Equatable {
  /// Filters proposals by their effective status. If null, this filter is not applied.
  final ProposalStatusFilter? status;

  /// Filters proposals based on whether they are marked as a favorite.
  /// If null, this filter is not applied.
  final bool? isFavorite;

  /// Filters proposals to only include those signed by this [author].
  /// If null, this filter is not applied.
  final CatalystId? author;

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

  /// Creates a set of filters for querying proposals.
  const ProposalsFiltersV2({
    this.status,
    this.isFavorite,
    this.author,
    this.categoryId,
    this.searchQuery,
    this.latestUpdate,
  });

  @override
  List<Object?> get props => [
    status,
    isFavorite,
    author,
    categoryId,
    searchQuery,
    latestUpdate,
  ];

  ProposalsFiltersV2 copyWith({
    Optional<ProposalStatusFilter>? status,
    Optional<bool>? isFavorite,
    Optional<CatalystId>? author,
    Optional<String>? categoryId,
    Optional<String>? searchQuery,
    Optional<Duration>? latestUpdate,
  }) {
    return ProposalsFiltersV2(
      status: status.dataOr(this.status),
      isFavorite: isFavorite.dataOr(this.isFavorite),
      author: author.dataOr(this.author),
      categoryId: categoryId.dataOr(this.categoryId),
      searchQuery: searchQuery.dataOr(this.searchQuery),
      latestUpdate: latestUpdate.dataOr(this.latestUpdate),
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
    if (author != null) {
      parts.add('author: $author');
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
