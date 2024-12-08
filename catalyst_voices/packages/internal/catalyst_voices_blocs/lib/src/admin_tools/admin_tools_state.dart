import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

/// The state of admin tools.
final class AdminToolsState extends Equatable {
  final bool enabled;
  final CampaignStage campaignStage;
  final AuthenticationStatus authStatus;

  const AdminToolsState({
    required this.enabled,
    required this.campaignStage,
    required this.authStatus,
  });

  AdminToolsState copyWith({
    bool? enabled,
    CampaignStage? campaignStage,
    AuthenticationStatus? authStatus,
  }) {
    return AdminToolsState(
      enabled: enabled ?? this.enabled,
      campaignStage: campaignStage ?? this.campaignStage,
      authStatus: authStatus ?? this.authStatus,
    );
  }

  @override
  List<Object?> get props => [enabled, campaignStage, authStatus];
}
