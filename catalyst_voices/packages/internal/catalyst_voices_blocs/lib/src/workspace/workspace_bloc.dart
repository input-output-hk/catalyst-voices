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
    on<TabChangedEvent>(_handleTabChange);
    on<ImportProposalEvent>(_importProposal);
    on<WatchUserProposalsEvent>(
      _watchUserProposals,
    );
    on<SearchQueryChangedEvent>(
      _handleQueryChange,
      // TODO(damian-molinski): implement debounce
      transformer: null,
    );
  }

  @override
  Future<void> close() {
    _proposalsSubscription?.cancel();
    _proposalsSubscription = null;
    return super.close();
  }

  Future<void> _handleQueryChange(
    SearchQueryChangedEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    // TODO(damian-molinski): implement filtering of _proposals

    final query = event.query;

    emit(state.copyWith(searchQuery: query));
  }

  Future<void> _handleTabChange(
    TabChangedEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    // TODO(damian-molinski): implement filtering of _proposals

    emit(state.copyWith(tab: event.tab));
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
        isLoading: true,
        draftProposalCount: 0,
        finalProposalCount: 0,
        proposals: const [],
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
      onError: (error) {
        if (isClosed) return;
      },
    );
  }

  Future<void> _watchUserProposals(
    WatchUserProposalsEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    _logger.info('Setup user proposals subscription');
    await _proposalsSubscription?.cancel();
    _proposalsSubscription = null;
    _setupProposalsSubscription();
  }
}
