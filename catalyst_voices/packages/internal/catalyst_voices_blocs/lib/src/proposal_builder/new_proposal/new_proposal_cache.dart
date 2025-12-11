import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class NewProposalCache extends Equatable {
  final SignedDocumentRef? categoryRef;
  final Campaign? activeCampaign;
  final CampaignTotalAsk? campaignTotalAsk;

  const NewProposalCache({
    this.categoryRef,
    this.activeCampaign,
    this.campaignTotalAsk,
  });

  @override
  List<Object?> get props => [
    categoryRef,
    activeCampaign,
    campaignTotalAsk,
  ];

  NewProposalCache copyWith({
    Optional<SignedDocumentRef>? categoryRef,
    Optional<Campaign>? activeCampaign,
    Optional<CampaignTotalAsk>? campaignTotalAsk,
  }) {
    return NewProposalCache(
      categoryRef: categoryRef.dataOr(this.categoryRef),
      activeCampaign: activeCampaign.dataOr(this.activeCampaign),
      campaignTotalAsk: campaignTotalAsk.dataOr(this.campaignTotalAsk),
    );
  }
}
