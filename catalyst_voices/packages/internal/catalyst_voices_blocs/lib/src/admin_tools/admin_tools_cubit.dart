import 'package:catalyst_voices_blocs/src/admin_tools/admin_tools_state.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Manages the admin tools.
///
/// The admin tools can be used to override application state (UI).
final class AdminToolsCubit extends Cubit<AdminToolsState> {
  AdminToolsCubit()
      : super(
          const AdminToolsState(
            enabled: false,
            campaignStage: CampaignStage.scheduled,
            sessionStatus: SessionStatus.actor,
          ),
        );

  void enable() {
    emit(state.copyWith(enabled: true));
  }

  void disable() {
    emit(state.copyWith(enabled: false));
  }

  void updateCampaignStage(CampaignStage stage) {
    emit(state.copyWith(campaignStage: stage));
  }

  void updateSessionStatus(SessionStatus status) {
    emit(state.copyWith(sessionStatus: status));
  }
}
