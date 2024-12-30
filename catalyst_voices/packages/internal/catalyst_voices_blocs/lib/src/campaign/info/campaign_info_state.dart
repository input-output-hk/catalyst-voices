import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

/// The state of the campaign.
final class CampaignInfoState extends Equatable {
  final bool isLoading;
  final CampaignInfo? campaign;

  const CampaignInfoState({
    this.isLoading = false,
    this.campaign,
  });

  @override
  List<Object?> get props => [isLoading, campaign];
}
