import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

final _logger = Logger('WorkspaceBloc');

/// Manages users' proposals. Allows to load, import, export, forget, unlock and delete proposals.
final class WorkspaceBloc extends Bloc<WorkspaceEvent, WorkspaceState>
    with BlocSignalEmitterMixin<WorkspaceSignal, WorkspaceState>, BlocErrorEmitterMixin {
  final UserService _userService;
  final CampaignService _campaignService;
  final ProposalService _proposalService;
  final DocumentMapper _documentMapper;
  final DownloaderService _downloaderService;

  WorkspaceBlocCache _cache = const WorkspaceBlocCache();

  StreamSubscription<CatalystId?>? _activeAccountIdSub;
  StreamSubscription<Campaign?>? _activeCampaignSub;
  StreamSubscription<List<UsersProposalOverview>>? _dataPageSub;
  StreamSubscription<int>? _invitationsAndApprovalsSub;

  WorkspaceBloc(
    this._userService,
    this._campaignService,
    this._proposalService,
    this._documentMapper,
    this._downloaderService,
  ) : super(const WorkspaceState()) {
    on<InitWorkspaceEvent>(_onInit);
    on<ChangeWorkspaceFilters>(_onChangeFilters);
    on<DeleteDraftProposalEvent>(_onDeleteProposal);
    on<ExportProposal>(_onExportProposal);
    on<ForgetProposalEvent>(_onForgetProposal);
    on<GetTimelineItemsEvent>(_onGetTimelineItems);
    on<ImportProposalEvent>(_onImportProposal);
    on<UnlockProposalEvent>(_onUnlockProposal);
    on<WatchUserCatalystIdEvent>(_onWatchUserCatalystId);
    on<WatchActiveCampaignChangeEvent>(_onWatchActiveCampaignChange);
    on<InternalDataChangeEvent>(_onInternalDataChange);
    on<LeaveProposalEvent>(_onLeaveProposal);
    on<WorkspaceInvitationsAndApprovalsCount>(_onInvitationsAndApprovalsCountChange);

    unawaited(
      _userService.watchUnlockedActiveAccount
          .map((event) => event?.catalystId)
          .first
          .then(_handleActiveAccountIdChange),
    );
  }

  Future<Campaign?> get _campaign async {
    final cachedCampaign = _cache.campaign;
    if (cachedCampaign != null) {
      return cachedCampaign;
    }

    final campaign = await _campaignService.getActiveCampaign();
    _cache = _cache.copyWith(campaign: Optional(campaign));

    return campaign;
  }

  @override
  Future<void> close() async {
    await _activeAccountIdSub?.cancel();
    _activeAccountIdSub = null;

    await _dataPageSub?.cancel();
    _dataPageSub = null;

    await _activeCampaignSub?.cancel();
    _activeCampaignSub = null;

    await _invitationsAndApprovalsSub?.cancel();
    _invitationsAndApprovalsSub = null;

    return super.close();
  }

  DocumentDataContent _buildDocumentContent(Document document) {
    return _documentMapper.toContent(document);
  }

  DocumentDataMetadata _buildDocumentMetadata(ProposalDocument document) {
    return DocumentDataMetadata.proposal(
      id: document.metadata.id,
      template: document.metadata.templateRef,
      parameters: document.metadata.parameters,
      authors: document.metadata.authors,
      collaborators: document.metadata.collaborators,
    );
  }

  void _handleActiveAccountIdChange(CatalystId? id) {
    if (isClosed) return;

    _cache = _cache.copyWith(activeAccountId: Optional(id));

    unawaited(_rebuildDataPageSub());
    _rebuildInvitationsAndApprovalsCountSub();
  }

  void _handleActiveCampaignChange(Campaign? campaign) {
    if (_cache.campaign?.id == campaign?.id) {
      return;
    }

    _cache = _cache.copyWith(campaign: Optional(campaign));

    add(const GetTimelineItemsEvent());
    unawaited(_rebuildDataPageSub());
  }

  void _handleDataChange(List<UsersProposalOverview> items) {
    if (isClosed) return;

    add(InternalDataChangeEvent(items));
  }

  Future<void> _onChangeFilters(ChangeWorkspaceFilters event, Emitter<WorkspaceState> emit) async {
    final filter = event.filters;

    _cache = _cache.copyWith(workspaceFilter: filter);

    emit(
      state.copyWith(
        userProposals: state.userProposals.copyWith(currentFilter: filter),
        isLoading: true,
      ),
    );

    await _rebuildDataPageSub();

    if (!isClosed && !event.showLoading) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onDeleteProposal(
    DeleteDraftProposalEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    try {
      emit(state.copyWith(isLoading: true));
      await _proposalService.deleteDraftProposal(event.ref);

      // Remove proposal from cache and rebuild state
      _removeProposalFromCache(event.ref);
      emit(state.copyWith(userProposals: _rebuildProposalsState()));

      emitSignal(const DeletedDraftWorkspaceSignal());
    } catch (error, stackTrace) {
      _logger.severe('Delete proposal failed', error, stackTrace);
      emitError(const LocalizedProposalDeletionException());
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onExportProposal(ExportProposal event, Emitter<WorkspaceState> emit) async {
    try {
      final docData = await _proposalService.getProposalDetail(id: event.ref);

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

  Future<void> _onForgetProposal(ForgetProposalEvent event, Emitter<WorkspaceState> emit) async {
    final proposal = _cache.proposals?.firstWhereOrNull(
      (e) => e.id == event.ref,
    );
    if (proposal == null || proposal.id is! SignedDocumentRef) {
      return emitError(const LocalizedUnknownException());
    }
    try {
      emit(state.copyWith(isLoading: true));
      await _proposalService.forgetProposal(
        proposalId: proposal.id as SignedDocumentRef,
      );

      // Remove proposal from cache and rebuild state
      _removeProposalFromCache(event.ref);
      emit(state.copyWith(userProposals: _rebuildProposalsState()));

      emitSignal(const ForgetProposalSuccessWorkspaceSignal());
    } catch (e, stackTrace) {
      emitError(LocalizedException.create(e));
      _logger.severe('Error forgetting proposal', e, stackTrace);
    } finally {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onGetTimelineItems(
    GetTimelineItemsEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    final campaign = await _campaign;
    if (campaign == null) {
      return emitError(const LocalizedUnknownException());
    }

    final timeline = campaign.timeline.phases.map(CampaignTimelineViewModel.fromModel).toList();

    emit(state.copyWith(timelineItems: timeline, fundNumber: campaign.fundNumber));
    emitSignal(SubmissionCloseDate(date: state.submissionCloseDate));
  }

  Future<void> _onImportProposal(ImportProposalEvent event, Emitter<WorkspaceState> emit) async {
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

  Future<void> _onInit(InitWorkspaceEvent event, Emitter<WorkspaceState> emit) async {
    _resetCache();
    add(const WatchUserCatalystIdEvent());
    add(const WatchActiveCampaignChangeEvent());
    _rebuildInvitationsAndApprovalsCountSub();
  }

  void _onInternalDataChange(InternalDataChangeEvent event, Emitter<WorkspaceState> emit) {
    _cache = _cache.copyWith(proposals: Optional(event.proposals));
    final newState = _rebuildProposalsState();
    emit(state.copyWith(userProposals: newState, isLoading: false));
  }

  void _onInvitationsAndApprovalsCountChange(
    WorkspaceInvitationsAndApprovalsCount event,
    Emitter<WorkspaceState> emit,
  ) {
    emit(state.copyWith(invitationsApprovalsCount: event.count));
  }

  Future<void> _onLeaveProposal(LeaveProposalEvent event, Emitter<WorkspaceState> emit) async {
    try {
      final ref = event.id;
      if (ref is! SignedDocumentRef) {
        throw ArgumentError('Cannot leave draft proposal with ref: $ref');
      }

      await _proposalService.submitCollaboratorProposalAction(
        proposalId: ref,
        action: CollaboratorProposalAction.leaveProposal,
      );
    } catch (error, stackTrace) {
      _logger.severe('onLeaveProposal', error, stackTrace);
      if (!isClosed) {
        emitError(LocalizedException.create(error));
      }
    }
  }

  Future<void> _onUnlockProposal(UnlockProposalEvent event, Emitter<WorkspaceState> emit) async {
    final proposal = _cache.proposals?.firstWhereOrNull(
      (e) => e.id == event.ref,
    );
    if (proposal == null || proposal.id is! SignedDocumentRef) {
      return emitError(const LocalizedUnknownException());
    }
    await _proposalService.unlockProposal(proposalId: proposal.id as SignedDocumentRef);
    emitSignal(OpenProposalBuilderSignal(ref: event.ref));
  }

  Future<void> _onWatchActiveCampaignChange(
    WatchActiveCampaignChangeEvent event,
    Emitter<WorkspaceState> state,
  ) async {
    await _activeCampaignSub?.cancel();

    _activeCampaignSub = _campaignService.watchActiveCampaign
        .distinct((previous, next) => previous?.id == next?.id)
        .listen(_handleActiveCampaignChange);
  }

  Future<void> _onWatchUserCatalystId(
    WatchUserCatalystIdEvent event,
    Emitter<WorkspaceState> emit,
  ) async {
    await _activeAccountIdSub?.cancel();

    _activeAccountIdSub = _userService.watchUnlockedActiveAccount
        .map((event) => event?.catalystId)
        .distinct()
        .listen(_handleActiveAccountIdChange);
  }

  ProposalsFiltersV2 _proposalFilters() {
    final activeAccountId = _cache.activeAccountId;
    if (activeAccountId == null) {
      return const ProposalsFiltersV2();
    }

    return ProposalsFiltersV2(
      relationships: switch (_cache.workspaceFilter) {
        WorkspaceFilters.allProposals => {
          OriginalAuthor(activeAccountId),
          CollaborationInvitation.accepted(activeAccountId),
        },
        WorkspaceFilters.mainProposer => {
          OriginalAuthor(activeAccountId),
        },
        WorkspaceFilters.collaborator => {
          CollaborationInvitation.accepted(activeAccountId),
        },
      },
    );
  }

  Future<void> _rebuildDataPageSub() async {
    final proposalsFilters = _proposalFilters();

    final activeCampaign = await _campaign;

    if (isClosed) return;

    await _dataPageSub?.cancel();
    _dataPageSub = _proposalService
        .watchWorkspaceProposalsBrief(filters: proposalsFilters)
        .map((briefs) {
          return briefs.map((brief) {
            return UsersProposalOverview.fromProposalBriefData(
              proposalData: brief,
              fromActiveCampaign: activeCampaign?.fundNumber == brief.fundNumber,
              activeAccountId: _cache.activeAccountId,
            );
          }).toList();
        })
        .distinct(listEquals)
        .listen(_handleDataChange);
  }

  void _rebuildInvitationsAndApprovalsCountSub() {
    final activeCatalystId = _cache.activeAccountId;
    if (activeCatalystId == null) {
      return add(const WorkspaceInvitationsAndApprovalsCount(0));
    }

    unawaited(_invitationsAndApprovalsSub?.cancel());
    _invitationsAndApprovalsSub = _proposalService
        .watchInvitesApprovalsCount(id: activeCatalystId)
        .map((countInfo) => countInfo.totalCount)
        .distinct()
        .listen((count) => add(WorkspaceInvitationsAndApprovalsCount(count)));
  }

  /// Rebuilds WorkspaceStateUserProposals from the current cache.
  /// This ensures derived views (published, notPublished, hasComments) stay in sync.
  WorkspaceStateUserProposals _rebuildProposalsState() {
    final proposals = _cache.proposals ?? [];
    final filter = _cache.workspaceFilter;
    return WorkspaceStateUserProposals.fromList(proposals, filter);
  }

  /// Removes a proposal from the cache by its reference.
  void _removeProposalFromCache(DocumentRef ref) {
    final updatedProposals = _cache.proposals?.where((e) => e.id.id != ref.id).toList() ?? [];
    _cache = _cache.copyWith(proposals: Optional(updatedProposals));
  }

  void _resetCache() {
    final activeAccountId = _userService.user.activeAccount?.catalystId;
    final filters = _proposalFilters();

    _cache = WorkspaceBlocCache(
      proposalsFilters: filters,
      activeAccountId: activeAccountId,
    );
  }
}
