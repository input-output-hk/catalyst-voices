part of 'campaign_status_cubit.dart';

enum CampaignStatus {
  draft,
  published;

  bool get isDraft => this == draft;
  bool isSelected(CampaignStatus? selected) => this == selected;
}

@immutable
sealed class CampaignStatusState {
  const CampaignStatusState();
}

final class LoadingCampaignStatusState extends CampaignStatusState {}

final class ChangedCampaignStatusState extends CampaignStatusState {
  final CampaignStatus status;

  const ChangedCampaignStatusState(this.status);
}
