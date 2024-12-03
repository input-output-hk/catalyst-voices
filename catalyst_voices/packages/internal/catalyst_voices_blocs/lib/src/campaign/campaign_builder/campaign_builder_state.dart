part of 'campaign_builder_cubit.dart';

sealed class CampaignBuilderState extends Equatable {
  const CampaignBuilderState();
}

final class LoadingCampaignBuilderState extends CampaignBuilderState {
  const LoadingCampaignBuilderState();

  @override
  List<Object?> get props => [];
}

final class ChangedCampaignBuilderState extends CampaignBuilderState {
  final CampaignPublish status;

  const ChangedCampaignBuilderState(this.status);

  @override
  List<Object?> get props => [status];
}
