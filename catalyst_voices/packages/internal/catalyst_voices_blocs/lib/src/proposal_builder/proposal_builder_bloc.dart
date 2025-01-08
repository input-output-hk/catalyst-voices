import 'package:catalyst_voices_blocs/src/proposal_builder/proposal_builder_event.dart';
import 'package:catalyst_voices_blocs/src/proposal_builder/proposal_builder_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class ProposalBuilderBloc
    extends Bloc<ProposalBuilderEvent, ProposalBuilderState> {
  final CampaignService _campaignService;

  final _answers = <NodeId, MarkdownData>{};
  final _guidances = <NodeId, List<Guidance>>{};

  String? proposalId;
  NodeId? _activeStepId;

  ProposalBuilderBloc(
    this._campaignService,
  ) : super(const ProposalBuilderState()) {
    on<LoadProposalEvent>(_loadProposal);
    on<UpdateStepAnswerEvent>(_updateStepAnswer);
    on<ActiveStepChangedEvent>(_handleActiveStepEvent);
  }

  Future<void> _loadProposal(
    LoadProposalEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    /*   _answers.clear();
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

    // TODO(damian-molinski): To be reimplemented.
    */ /*for (final section in template.sections) {
      for (final step in section.steps) {
        final id = (sectionId: section.id, stepId: step.id);
        _guidances[id] = step.guidances;
      }
    }
*/ /*
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
    );*/
  }

  void _updateStepAnswer(
    UpdateStepAnswerEvent event,
    Emitter<ProposalBuilderState> emit,
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
    Emitter<ProposalBuilderState> emit,
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
}
