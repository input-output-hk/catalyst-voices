import 'dart:async';

import 'package:catalyst_voices_blocs/src/common/bloc_error_emitter_mixin.dart';
import 'package:catalyst_voices_blocs/src/common/bloc_signal_emitter_mixin.dart';
import 'package:catalyst_voices_blocs/src/workspace/workspace_event.dart';
import 'package:catalyst_voices_blocs/src/workspace/workspace_signal.dart';
import 'package:catalyst_voices_blocs/src/workspace/workspace_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final _logger = Logger('WorkspaceBloc');

final class WorkspaceBloc extends Bloc<WorkspaceEvent, WorkspaceState>
    with
        BlocSignalEmitterMixin<WorkspaceSignal, WorkspaceState>,
        BlocErrorEmitterMixin {
  // ignore: unused_field
  final CampaignService _campaignService;
  final ProposalService _proposalService;
  final DocumentMapper _documentMapper;
  final DownloaderService _downloaderService;

  StreamSubscription<List<Proposal>>? _proposalsSub;

  // ignore: unused_field
  final List<Proposal> _proposals = [];

  WorkspaceBloc(
    this._campaignService,
    this._proposalService,
    this._documentMapper,
    this._downloaderService,
  ) : super(const WorkspaceState()) {
    on<LoadProposalsEvent>(_loadProposals);
    on<ImportProposalEvent>(_importProposal);
    on<ErrorLoadProposalsEvent>(_errorLoadProposals);
    on<WatchUserProposalsEvent>(_watchUserProposals);
    on<ExportProposal>(_exportProposal);
    on<DeleteDraftProposalEvent>(_deleteProposal);
    on<UnlockProposalEvent>(_unlockProposal);
    on<ForgetProposalEvent>(_forgetProposal);
    on<GetTimelineItemsEvent>(_getTimelineItems);
  }

  @override
  Future<void> close() {
    _cancelProposalSubscriptions();
    return super.close();
  }

  DocumentDataContent _buildDocumentContent(Document document) {
    return _documentMapper.toContent(document);
  }

  DocumentDataMetadata _buildDocumentMetadata(ProposalDocument document) {
    final selfRef = document.metadata.selfRef;
    final categoryId = document.metadata.categoryId;
    final templateRef = document.metadata.templateRef;

    return DocumentDataMetadata(
      type: DocumentType.proposalDocument,
      selfRef: selfRef,
      template: templateRef,
      categoryId: categoryId,
    );
  }

  Future<void> _cancelProposalSubscriptions() async {
    await _proposalsSub?.cancel();
    _proposalsSub = null;
  }

  Future<void> _deleteProposal(
    DeleteDraftProposalEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _proposalService.deleteDraftProposal(event.ref);
      emit(state.copyWith(userProposals: _removeProposal(event.ref)));
      emitSignal(const DeletedDraftWorkspaceSignal());
    } catch (error, stackTrace) {
      _logger.severe('Delete proposal failed', error, stackTrace);
      emitError(const LocalizedProposalDeletionException());
    } finally {
      emit(state.copyWith(isLoading: false));
    }
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

    await _cancelProposalSubscriptions();
  }

  Future<void> _exportProposal(
    ExportProposal event,
    Emitter<WorkspaceState> emit,
  ) async {
    try {
      final docData = await _proposalService.getProposal(ref: event.ref);

      final docMetadata = _buildDocumentMetadata(docData.document);
      final documentContent = _buildDocumentContent(docData.document.document);

      final encodedProposal = await _proposalService.encodeProposalForExport(
        document: DocumentData(
          metadata: docMetadata,
          content: documentContent,
        ),
      );

      final filename = '${event.prefix}_${event.ref.id}';
      const extension = ProposalDocument.exportFileExt;

      await _downloaderService.download(
        data: encodedProposal,
        filename: '$filename.$extension',
      );
    } catch (error, stackTrace) {
      _logger.severe('Exporting proposal failed', error, stackTrace);
      emitError(LocalizedException.create(error));
    }
  }

  Future<void> _forgetProposal(
    ForgetProposalEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    final proposal =
        state.userProposals.firstWhereOrNull((e) => e.selfRef == event.ref);
    if (proposal == null || proposal.selfRef is! SignedDocumentRef) {
      return emitError(const LocalizedUnknownException());
    }
    try {
      emit(state.copyWith(isLoading: true));
      await _proposalService.forgetProposal(
        proposalRef: proposal.selfRef as SignedDocumentRef,
        categoryId: proposal.categoryId,
      );
      emit(state.copyWith(userProposals: _removeProposal(event.ref)));
      emitSignal(const ForgetProposalSuccessWorkspaceSignal());
    } catch (e, stackTrace) {
      emitError(LocalizedException.create(e));
      _logger.severe('Error forgetting proposal', e, stackTrace);
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _getTimelineItems(
    GetTimelineItemsEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    final timelineItems = await _campaignService.getCampaignTimeline();
    final timeline =
        timelineItems.map(CampaignTimelineViewModel.fromModel).toList();

    emit(state.copyWith(timelineItems: timeline));
    emitSignal(SubmissionCloseDate(date: state.submissionCloseDate));
  }

  Future<void> _importProposal(
    ImportProposalEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      final ref = await _proposalService.importProposal(event.proposalData);
      emitSignal(ImportedProposalWorkspaceSignal(proposalRef: ref));
    } catch (error, stackTrace) {
      _logger.severe('Importing proposal failed', error, stackTrace);
      emit(state.copyWith(isLoading: false));
      emitError(LocalizedException.create(error));
    }
    // We don't need to emit isLoading false here because it will be emitted
    // in the stream subscription.
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

  List<Proposal> _removeProposal(
    DocumentRef proposalRef,
  ) {
    return [...state.userProposals]
      ..removeWhere((e) => e.selfRef.id == proposalRef.id);
  }

  void _setupProposalsSubscription() {
    _proposalsSub = _proposalService.watchUserProposals().listen(
      (proposals) {
        if (isClosed) return;
        _logger.info('Stream received ${proposals.length} proposals');
        add(LoadProposalsEvent(proposals));
      },
      onError: (Object error, StackTrace stackTrace) {
        if (isClosed) return;
        _logger.info('Users proposals stream error', error, stackTrace);
        add(ErrorLoadProposalsEvent(LocalizedException.create(error)));
      },
    );
  }

  Future<void> _unlockProposal(
    UnlockProposalEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    final proposal =
        state.userProposals.firstWhereOrNull((e) => e.selfRef == event.ref);
    if (proposal == null || proposal.selfRef is! SignedDocumentRef) {
      return emitError(const LocalizedUnknownException());
    }
    await _proposalService.unlockProposal(
      proposalRef: proposal.selfRef as SignedDocumentRef,
      categoryId: proposal.categoryId,
    );
    emitSignal(OpenProposalBuilderSignal(ref: event.ref));
  }

  Future<void> _watchUserProposals(
    WatchUserProposalsEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    // As stream is needed in a few places we don't want to create it every time
    if (_proposalsSub != null && state.error == null) {
      return;
    }

    _logger.info('Setup user proposals subscription');

    emit(
      state.copyWith(
        isLoading: true,
        error: const Optional.empty(),
      ),
    );

    _logger.info('$state and ${state.showProposals}');

    await _cancelProposalSubscriptions();
    _setupProposalsSubscription();
  }
}
