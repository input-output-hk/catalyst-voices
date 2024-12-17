import 'package:catalyst_voices_blocs/src/workspace/workspace_event.dart';
import 'package:catalyst_voices_blocs/src/workspace/workspace_state.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class WorkspaceBloc extends Bloc<WorkspaceEvent, WorkspaceState> {
  // ignore: unused_field
  final CampaignService _campaignService;

  WorkspaceBloc(
    this._campaignService,
  ) : super(const WorkspaceState()) {
    on<LoadProposalsEvent>(_loadProposals);
  }

  Future<void> _loadProposals(
    LoadProposalsEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    //
  }
}
