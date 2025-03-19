import 'dart:async';

import 'package:catalyst_voices_blocs/src/common/bloc_error_emitter_mixin.dart';
import 'package:catalyst_voices_blocs/src/workspace/workspace_event.dart';
import 'package:catalyst_voices_blocs/src/workspace/workspace_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _logger = Logger('WorkspaceBloc');

final class WorkspaceBloc extends Bloc<WorkspaceEvent, WorkspaceState>
    with BlocErrorEmitterMixin {
  // ignore: unused_field
  final CampaignService _campaignService;
  final ProposalService _proposalService;
  StreamSubscription<List<Proposal>>? _proposalsSubscription;

  // ignore: unused_field
  final List<Proposal> _proposals = [];

  WorkspaceBloc(
    this._campaignService,
    this._proposalService,
  ) : super(const WorkspaceState()) {
    on<LoadProposalsEvent>(_loadProposals);
    on<ImportProposalEvent>(_importProposal);
    on<ErrorLoadProposalsEvent>(_errorLoadProposals);
    on<WatchUserProposalsEvent>(
      _watchUserProposals,
    );
  }

  @override
  Future<void> close() {
    _proposalsSubscription?.cancel();
    _proposalsSubscription = null;
    return super.close();
  }

  Future<void> _errorLoadProposals(
    ErrorLoadProposalsEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    _logger.info('Error loading proposals');
    emit(
      state.copyWith(
        error: Optional(event.error),
        isLoading: false,
      ),
    );
    await _proposalsSubscription?.cancel();
    _proposalsSubscription = null;
  }

  Future<void> _importProposal(
    ImportProposalEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    try {
      final ref = await _proposalService.importProposal(event.proposalData);
      emit(state.copyWith(importedProposalRef: Optional(ref)));
    } catch (error, stackTrace) {
      _logger.severe('Importing proposal failed', error, stackTrace);
      emitError(const LocalizedUnknownException());
    }
  }

  Future<void> _loadProposals(
    LoadProposalsEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: false,
        error: const Optional.empty(),
        userProposals: event.proposals,
      ),
    );
  }

  void _setupProposalsSubscription() {
    _proposalsSubscription = _proposalService.watchUserProposals().listen(
      (proposals) {
        if (isClosed) return;
        _logger.info('Stream received ${proposals.length} proposals');
        add(LoadProposalsEvent(proposals));
      },
      onError: (Object error) {
        if (isClosed) return;
        _logger.info('Users proposals stream error', error);
        add(const ErrorLoadProposalsEvent(LocalizedUnknownException()));
      },
    );
  }

  Future<void> _watchUserProposals(
    WatchUserProposalsEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    _logger.info('Setup user proposals subscription');
    emit(
      state.copyWith(
        isLoading: true,
        error: const Optional.empty(),
      ),
    );
    await _proposalsSubscription?.cancel();
    _proposalsSubscription = null;
    _setupProposalsSubscription();
  }
}
