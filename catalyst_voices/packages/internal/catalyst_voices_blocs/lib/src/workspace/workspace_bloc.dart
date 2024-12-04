import 'package:catalyst_voices_blocs/src/workspace/workspace_event.dart';
import 'package:catalyst_voices_blocs/src/workspace/workspace_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class WorkspaceBloc extends Bloc<WorkspaceEvent, WorkspaceState> {
  final CampaignService _campaignService;

  final _answers = <SectionStepId, MarkdownString>{};

  WorkspaceBloc(
    this._campaignService,
  ) : super(const WorkspaceState()) {
    on<LoadCurrentProposalEvent>(_loadCurrentProposal);
    on<UpdateSectionStepAnswer>(_updateStepAnswer);
  }

  Future<void> _loadCurrentProposal(
    LoadCurrentProposalEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    _answers.clear();

    final activeCampaign = await _campaignService.getActiveCampaign();
    if (activeCampaign == null) {
      emit(state.copyWith(sections: []));
      return;
    }

    final template = activeCampaign.proposalTemplate;

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

  void _updateStepAnswer(
    UpdateSectionStepAnswer event,
    Emitter<WorkspaceState> emit,
  ) {
    final answer = event.data;
    if (answer != null) {
      _answers[event.id] = answer;
    } else {
      _answers.remove(event.id);
    }
  }
}
