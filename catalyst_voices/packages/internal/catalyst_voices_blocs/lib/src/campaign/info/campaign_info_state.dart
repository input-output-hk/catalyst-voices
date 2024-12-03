import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

/// The state of the campaign.
sealed class CampaignInfoState extends Equatable {
  const CampaignInfoState();
}

/// The campaign is loading.
final class LoadingCampaignInfoState extends CampaignInfoState {
  const LoadingCampaignInfoState();

  @override
  List<Object?> get props => [];
}

/// The loaded active campaign.
final class LoadedCampaignInfoState extends CampaignInfoState {
  final CampaignInfo? campaign;

  const LoadedCampaignInfoState({
    required this.campaign,
  });

  @override
  List<Object?> get props => [campaign];
}
