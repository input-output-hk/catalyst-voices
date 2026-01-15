import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class ProposalApprovalCubitCache extends Equatable {
  final CatalystId? activeAccountId;
  final Campaign? campaign;
  final List<ProposalBriefData>? items;

  const ProposalApprovalCubitCache({
    this.activeAccountId,
    this.campaign,
    this.items,
  });

  @override
  List<Object?> get props => [
    activeAccountId,
    campaign,
    items,
  ];

  ProposalApprovalCubitCache copyWith({
    Optional<CatalystId>? activeAccountId,
    Optional<Campaign>? campaign,
    Optional<List<ProposalBriefData>>? items,
  }) {
    return ProposalApprovalCubitCache(
      activeAccountId: activeAccountId.dataOr(this.activeAccountId),
      campaign: campaign.dataOr(this.campaign),
      items: items.dataOr(this.items),
    );
  }
}
