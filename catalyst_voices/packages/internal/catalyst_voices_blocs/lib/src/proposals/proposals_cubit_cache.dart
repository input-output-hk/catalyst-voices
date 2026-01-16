import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalsCubitCache extends Equatable {
  final Campaign? campaign;
  final CatalystId? activeAccountId;
  final ProposalsFiltersV2 filters;
  final ProposalsPageTab? tab;
  final ProposalsOrder? order;
  final List<CampaignCategory>? categories;
  final Page<ProposalBrief>? page;

  const ProposalsCubitCache({
    this.campaign,
    this.activeAccountId,
    this.tab,
    this.filters = const ProposalsFiltersV2(),
    this.order,
    this.categories,
    this.page,
  });

  @override
  List<Object?> get props => [
    campaign,
    activeAccountId,
    tab,
    filters,
    order,
    categories,
    page,
  ];

  ProposalsCubitCache copyWith({
    Optional<Campaign>? campaign,
    Optional<CatalystId>? activeAccountId,
    Optional<ProposalsPageTab>? tab,
    ProposalsFiltersV2? filters,
    Optional<ProposalsOrder>? order,
    Optional<List<CampaignCategory>>? categories,
    Map<ProposalsPageTab, ProposalsFiltersV2>? proposalsCountFilters,
    Optional<Page<ProposalBrief>>? page,
  }) {
    return ProposalsCubitCache(
      campaign: campaign.dataOr(this.campaign),
      activeAccountId: activeAccountId.dataOr(this.activeAccountId),
      tab: tab.dataOr(this.tab),
      filters: filters ?? this.filters,
      order: order.dataOr(this.order),
      categories: categories.dataOr(this.categories),
      page: page.dataOr(this.page),
    );
  }
}
