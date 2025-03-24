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

  StreamSubscription<List<Proposal>>? _proposalsSubscription;

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
  }

  @override
  Future<void> close() {
    _proposalsSubscription?.cancel();
    _proposalsSubscription = null;
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

  Future<void> _deleteProposal(
    DeleteDraftProposalEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    try {
      await _proposalService.deleteDraftProposal(event.ref);
      emitSignal(const DeletedDraftWorkspaceSignal());
    } catch (error, stackTrace) {
      _logger.severe('Delete proposal failed', error, stackTrace);
      emitError(const LocalizedProposalDeletionException());
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
    await _proposalsSubscription?.cancel();
    _proposalsSubscription = null;
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
      emitError(const LocalizedUnknownException());
    }
  }

  Future<void> _importProposal(
    ImportProposalEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    try {
      final ref = await _proposalService.importProposal(event.proposalData);
      emitSignal(ImportedProposalWorkspaceSignal(proposalRef: ref));
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
        // // TODO(LynxLynxx): only for testing delete before PR
        // final proposalsToDelete = <Proposal>[];
        // for (var i = 0; i < proposals.length; i++) {
        //   if (i < 3) {
        //     proposalsToDelete.add(
        //       proposals[i].copyWith(
        //         publish: ProposalPublish.values[i],
        //         versions: [
        //           ProposalVersion(
        //             selfRef: proposals[i].selfRef.copyWith(
        //                   version: Optional(const UuidV7().toString()),
        //                 ),
        //             title: 'Title ver ${i + 1}',
        //             createdAt: DateTime.now(),
        //             publish: ProposalPublish.localDraft,
        //           ),
        //           ProposalVersion(
        //             selfRef: proposals[i].selfRef,
        //             title: 'Title ver ${i + 1}',
        //             createdAt: DateTime.now(),
        //             publish: ProposalPublish.publishedDraft,
        //           ),
        //         ],
        //       ),
        //     );
        //   } else {
        //     proposalsToDelete.add(proposals[i]);
        //   }
        // }

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
