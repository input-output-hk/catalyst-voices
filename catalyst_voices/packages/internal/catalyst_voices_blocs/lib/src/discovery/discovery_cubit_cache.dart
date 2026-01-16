import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class DiscoveryCubitCache extends Equatable {
  final Campaign? activeCampaign;
  final CampaignTotalAsk? campaignTotalAsk;

  const DiscoveryCubitCache({
    this.activeCampaign,
    this.campaignTotalAsk,
  });

  @override
  List<Object?> get props => [
    activeCampaign,
    campaignTotalAsk,
  ];

  DiscoveryCubitCache copyWith({
    Optional<Campaign>? activeCampaign,
    Optional<CampaignTotalAsk>? campaignTotalAsk,
  }) {
    return DiscoveryCubitCache(
      activeCampaign: activeCampaign.dataOr(this.activeCampaign),
      campaignTotalAsk: campaignTotalAsk.dataOr(this.campaignTotalAsk),
    );
  }
}
