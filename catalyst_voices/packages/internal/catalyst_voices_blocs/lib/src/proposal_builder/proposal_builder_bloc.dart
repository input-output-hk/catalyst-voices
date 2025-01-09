import 'package:catalyst_voices_blocs/src/proposal_builder/proposal_builder_event.dart';
import 'package:catalyst_voices_blocs/src/proposal_builder/proposal_builder_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _logger = Logger('ProposalBuilderBloc');

final class ProposalBuilderBloc
    extends Bloc<ProposalBuilderEvent, ProposalBuilderState> {
  // ignore: unused_field
  final CampaignService _campaignService;

  NodeId? _activeNodeId;

  ProposalBuilderBloc(
    this._campaignService,
  ) : super(const ProposalBuilderState()) {
    on<StartNewProposalEvent>(_startNewProposal);
    on<LoadProposalEvent>(_loadProposal);
    on<ActiveNodeChangedEvent>(
      _handleActiveStepEvent,
      transformer: (events, mapper) => events.distinct(),
    );
  }

  Future<void> _startNewProposal(
    StartNewProposalEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    _logger.finest('Starting new proposal');
  }

  Future<void> _loadProposal(
    LoadProposalEvent event,
    Emitter<ProposalBuilderState> emit,
  ) async {
    _logger.finest('Loading proposal[${event.id}]');
  }

  void _handleActiveStepEvent(
    ActiveNodeChangedEvent event,
    Emitter<ProposalBuilderState> emit,
  ) {
    final id = event.id;
    _logger.finest('Active node changed to [$id]');

    _activeNodeId = id;
  }
}
