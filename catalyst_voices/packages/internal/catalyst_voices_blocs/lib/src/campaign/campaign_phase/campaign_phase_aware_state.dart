import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

sealed class CampaignPhaseAwareState extends Equatable {
  const CampaignPhaseAwareState();

  @override
  List<Object?> get props => [];
}

final class DataCampaignPhaseAwareState extends CampaignPhaseAwareState {
  final Campaign campaign;

  const DataCampaignPhaseAwareState({required this.campaign});

  @override
  List<Object?> get props => [campaign];
}

final class ErrorCampaignPhaseAwareState extends CampaignPhaseAwareState {
  final LocalizedException error;

  const ErrorCampaignPhaseAwareState({required this.error});

  @override
  List<Object?> get props => [error];
}

final class LoadingCampaignPhaseAwareState extends CampaignPhaseAwareState {
  const LoadingCampaignPhaseAwareState();
}
