import 'package:catalyst_voices_blocs/src/workspace/editor/proposal_editor_event.dart';
import 'package:catalyst_voices_blocs/src/workspace/editor/proposal_editor_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class ProposalEditorBloc
    extends Bloc<ProposalEditorEvent, ProposalEditorState> {
  final CampaignService _campaignService;

  final _answers = <SectionStepId, MarkdownData>{};
  final _guidances = <SectionStepId, List<Guidance>>{};

  String? proposalId;
  SectionStepId? _activeStepId;

  ProposalEditorBloc(
    this._campaignService,
  ) : super(const ProposalEditorState()) {
    on<LoadProposalEvent>(_loadProposal);
    on<UpdateStepAnswerEvent>(_updateStepAnswer);
    on<ActiveStepChangedEvent>(_handleActiveStepEvent);
  }

  Future<void> _loadProposal(
    LoadProposalEvent event,
    Emitter<ProposalEditorState> emit,
  ) async {
    _answers.clear();
    _guidances.clear();

    final activeCampaign = await _campaignService.getActiveCampaign();
    if (activeCampaign == null) {
      emit(
        state.copyWith(
          sections: [],
          guidance: const ProposalGuidance(isNoneSelected: true),
        ),
      );
      return;
    }

    final template = activeCampaign.proposalTemplate;

    final sections = template.sections.map(_mapProposalSection).toList();

    for (final section in template.sections) {
      for (final step in section.steps) {
        final id = (sectionId: section.id, stepId: step.id);
        _guidances[id] = step.guidances;
      }
    }

    final activeStepId = _activeStepId;
    final guidances = _guidances[activeStepId] ?? <Guidance>[];
    final guidance = ProposalGuidance(
      isNoneSelected: activeStepId == null,
      guidances: guidances,
    );

    emit(
      state.copyWith(
        sections: sections,
        guidance: guidance,
      ),
    );
  }

  void _updateStepAnswer(
    UpdateStepAnswerEvent event,
    Emitter<ProposalEditorState> emit,
  ) {
    final answer = event.data;
    if (answer != null) {
      _answers[event.id] = answer;
    } else {
      _answers.remove(event.id);
    }
  }

  void _handleActiveStepEvent(
    ActiveStepChangedEvent event,
    Emitter<ProposalEditorState> emit,
  ) {
    _activeStepId = event.id;

    final activeStepId = _activeStepId;
    final guidances = _guidances[activeStepId] ?? <Guidance>[];
    final guidance = ProposalGuidance(
      isNoneSelected: activeStepId == null,
      guidances: guidances,
    );

    emit(state.copyWith(guidance: guidance));
  }

  WorkspaceSection _mapProposalSection(ProposalSection section) {
    return WorkspaceSection(
      id: section.id,
      name: section.name,
      steps: section.steps.map(
        (step) {
          final id = (sectionId: section.id, stepId: step.id);

          return RichTextStep(
            id: step.id,
            sectionId: section.id,
            name: step.name,
            description: step.description,
            initialData: _answers[id] ?? step.answer,
          );
        },
      ).toList(),
    );
  }
}
