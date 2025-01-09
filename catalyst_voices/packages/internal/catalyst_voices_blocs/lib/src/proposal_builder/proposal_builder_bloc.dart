import 'package:catalyst_voices_blocs/src/proposal_builder/proposal_builder_event.dart';
import 'package:catalyst_voices_blocs/src/proposal_builder/proposal_builder_state.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _logger = Logger('ProposalBuilderBloc');

final class ProposalBuilderBloc
    extends Bloc<ProposalBuilderEvent, ProposalBuilderState> {
  // ignore: unused_field
  final CampaignService _campaignService;

  ProposalBuilderBloc(
    this._campaignService,
  ) : super(const ProposalBuilderState()) {
    on<StartNewProposalEvent>(_startNewProposal);
    on<LoadProposalEvent>(_loadProposal);
    on<ActiveStepChangedEvent>(_handleActiveStepEvent);
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
    ActiveStepChangedEvent event,
    Emitter<ProposalBuilderState> emit,
  ) {}
}
