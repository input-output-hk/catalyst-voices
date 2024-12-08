import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

/// The state of admin tools.
final class AdminToolsState extends Equatable {
  final bool enabled;
  final CampaignStage campaignStage;
  final SessionStatus sessionStatus;

  const AdminToolsState({
    required this.enabled,
    required this.campaignStage,
    required this.sessionStatus,
  });

  AdminToolsState copyWith({
    bool? enabled,
    CampaignStage? campaignStage,
    SessionStatus? sessionStatus,
  }) {
    return AdminToolsState(
      enabled: enabled ?? this.enabled,
      campaignStage: campaignStage ?? this.campaignStage,
      sessionStatus: sessionStatus ?? this.sessionStatus,
    );
  }

  @override
  List<Object?> get props => [enabled, campaignStage, sessionStatus];
}
