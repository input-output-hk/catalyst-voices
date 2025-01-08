import 'package:catalyst_voices_blocs/src/proposal_builder/proposal_builder_event.dart';
import 'package:catalyst_voices_blocs/src/proposal_builder/proposal_builder_state.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class ProposalBuilderBloc
    extends Bloc<ProposalBuilderEvent, ProposalBuilderState> {
  // ignore: unused_field
  final CampaignService _campaignService;

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
  ) async {}

  void _updateStepAnswer(
    UpdateStepAnswerEvent event,
    Emitter<ProposalBuilderState> emit,
  ) {}

  void _handleActiveStepEvent(
    ActiveStepChangedEvent event,
    Emitter<ProposalBuilderState> emit,
  ) {}
}
