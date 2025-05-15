import 'package:catalyst_voices_blocs/src/admin_tools/admin_tools_state.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract interface class AdminTools {
  /// The current state of admin tools.
  AdminToolsState get state;

  /// A stream with updates for admin tools state.
  Stream<AdminToolsState> get stream;
}

/// Manages the admin tools.
///
/// The admin tools can be used to override application state (UI).
final class AdminToolsCubit extends Cubit<AdminToolsState>
    implements AdminTools {
  AdminToolsCubit() : super(const AdminToolsState());

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
