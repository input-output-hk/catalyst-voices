import 'package:catalyst_voices_blocs/src/workspace/workspace_event.dart';
import 'package:catalyst_voices_blocs/src/workspace/workspace_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class WorkspaceBloc extends Bloc<WorkspaceEvent, WorkspaceState> {
  final CampaignService _campaignService;

  var _builder = const ProposalBuilder(sections: []);

  WorkspaceBloc(
    this._campaignService,
  ) : super(const WorkspaceState()) {
    on<LoadCurrentProposalEvent>(_loadCurrentProposal);
  }

  Future<void> _loadCurrentProposal(
    LoadCurrentProposalEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    final activeCampaign = await _campaignService.getActiveCampaign();
    if (activeCampaign == null) {
      emit(state.copyWith(sections: []));
      return;
    }

    final template = activeCampaign.proposalTemplate;
    _builder = ProposalBuilder(sections: List.from(template.sections));

    final sections = template.sections.map(
      (section) {
        return WorkspaceSection(
          id: section.id,
          name: section.name,
          steps: section.steps.map(
            (step) {
              return RichTextStep(
                id: step.id,
                sectionId: section.id,
                name: step.name,
                description: step.description,
                initialData: step.answer,
              );
            },
          ).toList(),
        );
      },
    ).toList();

    emit(state.copyWith(sections: sections));
  }
}
