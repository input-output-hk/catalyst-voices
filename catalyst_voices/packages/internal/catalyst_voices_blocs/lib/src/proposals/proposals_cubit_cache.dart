import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalsCubitCache extends Equatable {
  final Campaign? campaign;
  final Page<Proposal>? page;
  final ProposalsFilters filters;
  final List<CampaignCategory>? categories;
  final ProposalsCount count;

  const ProposalsCubitCache({
    this.campaign,
    this.page,
    this.filters = const ProposalsFilters(),
    this.categories,
    this.count = const ProposalsCount(),
  });

  @override
  List<Object?> get props => [
        campaign,
        page,
        filters,
        categories,
        count,
      ];

  ProposalsCubitCache copyWith({
    Optional<Campaign>? campaign,
    Optional<Page<Proposal>>? page,
    ProposalsFilters? filters,
    Optional<List<CampaignCategory>>? categories,
    ProposalsCount? count,
  }) {
    return ProposalsCubitCache(
      campaign: campaign.dataOr(this.campaign),
      page: page.dataOr(this.page),
      filters: filters ?? this.filters,
      categories: categories.dataOr(this.categories),
      count: count ?? this.count,
    );
  }
}
