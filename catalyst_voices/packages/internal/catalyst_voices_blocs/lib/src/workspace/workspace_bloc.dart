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

/// Manages users' proposals. Allows to load, import, export, forget, unlock and delete proposals.
final class WorkspaceBloc extends Bloc<WorkspaceEvent, WorkspaceState>
    with BlocSignalEmitterMixin<WorkspaceSignal, WorkspaceState>, BlocErrorEmitterMixin {
  // ignore: unused_field
  final CampaignService _campaignService;
  final ProposalService _proposalService;
  final DocumentMapper _documentMapper;
  final DownloaderService _downloaderService;
  Campaign? _cachedCampaign;

  StreamSubscription<List<DetailProposal>>? _proposalsSub;

  // ignore: unused_field
  final List<DetailProposal> _proposals = [];

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
  Future<void> close() async {
    await _cancelProposalSubscriptions();
    return super.close();
  }

  DocumentDataContent _buildDocumentContent(Document document) {
    return _documentMapper.toContent(document);
  }

  DocumentDataMetadata _buildDocumentMetadata(ProposalDocument document) {
    return DocumentDataMetadata.proposal(
      selfRef: document.metadata.selfRef,
      template: document.metadata.templateRef,
      parameters: document.metadata.parameters,
      authors: document.metadata.authors,
    );
  }

  Future<void> _cancelProposalSubscriptions() async {
    await _proposalsSub?.cancel();
    _proposalsSub = null;
  }

  Future<void> _deleteProposal(DeleteDraftProposalEvent event, Emitter<WorkspaceState> emit) async {
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
    emit(state.copyWith(error: Optional(event.error), isLoading: false));

    await _cancelProposalSubscriptions();
  }

  Future<void> _exportProposal(ExportProposal event, Emitter<WorkspaceState> emit) async {
    try {
      final docData = await _proposalService.getProposalDetail(ref: event.ref);

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

      await _downloaderService.download(data: encodedProposal, filename: '$filename.$extension');
    } catch (error, stackTrace) {
      _logger.severe('Exporting proposal failed', error, stackTrace);
      emitError(LocalizedException.create(error));
    }
  }

  Future<void> _forgetProposal(ForgetProposalEvent event, Emitter<WorkspaceState> emit) async {
    final proposal = state.userProposals.firstWhereOrNull((e) => e.selfRef == event.ref);
    if (proposal == null || proposal.selfRef is! SignedDocumentRef) {
      return emitError(const LocalizedUnknownException());
    }
    try {
      emit(state.copyWith(isLoading: true));
      await _proposalService.forgetProposal(
        proposalRef: proposal.selfRef as SignedDocumentRef,
        proposalParameters: proposal.parameters,
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
    final campaign = await _campaignService.getActiveCampaign();
    _cachedCampaign = campaign;

    if (campaign == null) {
      return emitError(const LocalizedUnknownException());
    }

    final timeline = campaign.timeline.phases.map(CampaignTimelineViewModel.fromModel).toList();

    emit(state.copyWith(timelineItems: timeline, fundNumber: campaign.fundNumber));
    emitSignal(SubmissionCloseDate(date: state.submissionCloseDate));
  }

  Future<void> _importProposal(ImportProposalEvent event, Emitter<WorkspaceState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));
      final ref = await _proposalService.importProposal(event.proposalData);
      emitSignal(ImportedProposalWorkspaceSignal(proposalRef: ref));
    } on DocumentImportInvalidDataException {
      emitError(const LocalizedDocumentImportInvalidDataException());
    } catch (error, stackTrace) {
      _logger.warning('Importing proposal failed', error, stackTrace);
      emitError(LocalizedException.create(error));
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _loadProposals(LoadProposalsEvent event, Emitter<WorkspaceState> emit) async {
    emit(
      state.copyWith(
        isLoading: false,
        error: const Optional.empty(),
        userProposals: event.proposals,
      ),
    );
  }

  Future<List<UsersProposalOverview>> _mapProposalToViewModel(
    List<DetailProposal> proposals,
  ) async {
    final futures = proposals.map((proposal) async {
      _cachedCampaign ??= await _campaignService.getActiveCampaign();

      // TODO(damian-molinski): proposal should have ref to campaign
      final campaigns = Campaign.all;

      final categories = campaigns.expand((element) => element.categories);
      final category = categories.firstWhereOrNull(
        (e) => proposal.parameters.containsId(e.selfRef.id),
      );

      // TODO(damian-molinski): refactor it
      final fundNumber = category != null
          ? campaigns.firstWhere((campaign) => campaign.hasCategory(category.selfRef.id)).fundNumber
          : 0;

      final fromActiveCampaign = fundNumber == _cachedCampaign?.fundNumber;

      return UsersProposalOverview.fromProposal(
        proposal,
        fundNumber,
        category?.formattedCategoryName ?? '',
        fromActiveCampaign: fromActiveCampaign,
      );
    }).toList();

    return Future.wait(futures);
  }

  List<UsersProposalOverview> _removeProposal(
    DocumentRef proposalRef,
  ) {
    return [...state.userProposals]..removeWhere((e) => e.selfRef.id == proposalRef.id);
  }

  void _setupProposalsSubscription() {
    _proposalsSub = _proposalService.watchUserProposals().listen(
      (proposals) async {
        if (isClosed) return;
        _logger.info('Stream received ${proposals.length} proposals');
        final mappedProposals = await _mapProposalToViewModel(proposals);
        add(LoadProposalsEvent(mappedProposals));
      },
      onError: (Object error, StackTrace stackTrace) {
        if (isClosed) return;
        _logger.info('Users proposals stream error', error, stackTrace);
        add(ErrorLoadProposalsEvent(LocalizedException.create(error)));
      },
    );
  }

  Future<void> _unlockProposal(UnlockProposalEvent event, Emitter<WorkspaceState> emit) async {
    final proposal = state.userProposals.firstWhereOrNull((e) => e.selfRef == event.ref);
    if (proposal == null || proposal.selfRef is! SignedDocumentRef) {
      return emitError(const LocalizedUnknownException());
    }
    await _proposalService.unlockProposal(
      proposalRef: proposal.selfRef as SignedDocumentRef,
      proposalParameters: proposal.parameters,
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

    emit(state.copyWith(isLoading: true, error: const Optional.empty()));

    _logger.info('$state and ${state.showProposals}');

    await _cancelProposalSubscriptions();
    _setupProposalsSubscription();
  }
}
