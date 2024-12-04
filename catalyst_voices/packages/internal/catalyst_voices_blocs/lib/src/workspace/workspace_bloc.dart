import 'package:catalyst_voices_blocs/src/workspace/workspace_event.dart';
import 'package:catalyst_voices_blocs/src/workspace/workspace_state.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class WorkspaceBloc extends Bloc<WorkspaceEvent, WorkspaceState> {
  WorkspaceBloc() : super(const WorkspaceState()) {
    on<LoadCurrentProposalEvent>(_loadCurrentProposal);
  }

  Future<void> _loadCurrentProposal(
    LoadCurrentProposalEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    const sections = <Section>[
      WorkspaceSection(
        id: 0,
        name: 'Proposal solution',
        steps: [
          RichTextStep(
            id: 0,
            sectionId: 0,
            name: 'Problem perspective',
            description:
                "What is your perspective on the problem you're solving?",
          ),
        ],
      ),
    ];

    emit(state.copyWith(sections: sections));
  }
}
