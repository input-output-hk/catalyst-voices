import 'package:catalyst_voices_blocs/src/proposal_builder/proposal_builder_event.dart';
import 'package:catalyst_voices_blocs/src/proposal_builder/proposal_builder_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _logger = Logger('ProposalBuilderBloc');

final class ProposalBuilderBloc
    extends Bloc<ProposalBuilderEvent, ProposalBuilderState> {
  final CampaignService _campaignService;
  final ProposalService _proposalService;

  NodeId? _activeNodeId;

  ProposalBuilderBloc(
    this._campaignService,
    this._proposalService,
  ) : super(const ProposalBuilderState()) {
    on<LoadDefaultProposalTemplateEvent>(_loadDefaultProposalTemplate);
    on<LoadProposalTemplateEvent>(_loadProposalTemplate);
    on<LoadProposalEvent>(_loadProposal);
    on<ActiveNodeChangedEvent>(
      _handleActiveStepEvent,
      transformer: (events, mapper) => events.distinct(),
    );
  }

  Future<void> _loadDefaultProposalTemplate(
    LoadDefaultProposalTemplateEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    _logger.info('Loading default proposal template');

    final campaign = await _campaignService.getActiveCampaign();

    final proposalTemplate = campaign?.proposalTemplate;
  }

  Future<void> _loadProposalTemplate(
    LoadProposalTemplateEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    _logger.info('Loading proposal template[${event.id}]');

    final proposalTemplate = await _proposalService.getProposalTemplate(
      id: event.id,
    );
  }

  Future<void> _loadProposal(
    LoadProposalEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    _logger.info('Loading proposal[${event.id}]');

    final proposal = await _proposalService.getProposal(id: event.id);
  }

  void _handleActiveStepEvent(
    ActiveNodeChangedEvent event,
    Emitter<ProposalBuilderState> emit,
  ) {
    _logger.info('Active node changed to [${event.id}]');

    _activeNodeId = event.id;
  }
}
