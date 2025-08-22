import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

sealed class CampaignPhaseAwareState extends Equatable {
  const CampaignPhaseAwareState();

  CampaignPhaseType? get activeCampaignPhaseType => null;

  @override
  List<Object?> get props => [];
}

final class DataCampaignPhaseAwareState extends CampaignPhaseAwareState {
  @override
  final CampaignPhaseType? activeCampaignPhaseType;
  final List<CampaignPhaseState> phasesStates;
  final int fundNumber;

  const DataCampaignPhaseAwareState({
    required this.activeCampaignPhaseType,
    required this.phasesStates,
    required this.fundNumber,
  });

  @override
  List<Object?> get props => [activeCampaignPhaseType, phasesStates, fundNumber];

  CampaignPhaseState getPhaseStatus(CampaignPhaseType phaseType) {
    return phasesStates.firstWhere((e) => e.phase.type == phaseType);
  }
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

final class NoActiveCampaignPhaseAwareState extends CampaignPhaseAwareState {
  const NoActiveCampaignPhaseAwareState();
}
