import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalsCubitCache extends Equatable {
  final ProposalsFilters filters;
  final List<CampaignCategory>? categories;
  final ProposalsFiltersCount count;

  const ProposalsCubitCache({
    this.filters = const ProposalsFilters(),
    this.categories,
    this.count = const ProposalsFiltersCount({}),
  });

  @override
  List<Object?> get props => [
        filters,
        categories,
        count,
      ];

  ProposalsCubitCache copyWith({
    ProposalsFilters? filters,
    Optional<List<CampaignCategory>>? categories,
    ProposalsFiltersCount? count,
  }) {
    return ProposalsCubitCache(
      filters: filters ?? this.filters,
      categories: categories.dataOr(this.categories),
      count: count ?? this.count,
    );
  }
}
