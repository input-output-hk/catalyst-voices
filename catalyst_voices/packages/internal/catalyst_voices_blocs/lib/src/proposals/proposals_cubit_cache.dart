import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalsCubitCache extends Equatable {
  final ProposalsFilters filters;
  final List<CampaignCategory>? categories;

  const ProposalsCubitCache({
    this.filters = const ProposalsFilters(),
    this.categories,
  });

  @override
  List<Object?> get props => [
        filters,
        categories,
      ];

  ProposalsCubitCache copyWith({
    ProposalsFilters? filters,
    Optional<List<CampaignCategory>>? categories,
  }) {
    return ProposalsCubitCache(
      filters: filters ?? this.filters,
      categories: categories.dataOr(this.categories),
    );
  }
}
