import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/document_viewer/mixins/document_viewer_collaborator_mixin.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';

final _logger = Logger('ProposalViewerCubit');

final class ProposalViewerCubit extends DocumentViewerCubit<ProposalViewerState>
    with
        DocumentViewerCollaboratorsMixin,
        BlocSignalEmitterMixin<ProposalSignal, ProposalViewerState> {
  // Subscription for watching proposal data updates
  StreamSubscription<ProposalDataV2?>? _proposalSub;

  ProposalViewerCubit(
    super.initialState,
    super.proposalService,
    super.userService,
    super.documentMapper,
    super.featureFlagsService,
  ) {
    // Initialize cache with specific type
    cache = ProposalViewerCache.empty().copyWith(
      activeAccountId: Optional(userService.user.activeAccount?.catalystId),
    );
  }

  /// Checks if viewing the latest version.
  bool get _isViewingLatestVersion {
    final proposalData = _proposalCache.proposalData;
    if (proposalData == null) return true;

    final currentVersion = cache.id?.ver;
    final versions = proposalData.versions ?? [];
    if (versions.isEmpty) return true;

    final latestVersion = versions.last.ver;
    return currentVersion == latestVersion;
  }

  // Helper to get typed cache
  ProposalViewerCache get _proposalCache => cache as ProposalViewerCache;

  @override
  Future<void> acceptCollaboratorInvitation() async {
    try {
      await super.acceptCollaboratorInvitation();
      if (!isClosed) {
        emit(state.copyWith(collaborator: const AcceptedCollaboratorInvitationState()));
      }
    } catch (error) {
      if (!isClosed) {
        emitError(LocalizedException.create(error));
      }
    }
  }

  @override
  Future<void> acceptFinalProposal() async {
    try {
      await super.acceptFinalProposal();

      if (!isClosed) {
        emit(state.copyWith(collaborator: const AcceptedFinalProposalConsentState()));
      }
    } catch (error) {
      if (!isClosed) {
        emitError(LocalizedException.create(error));
      }
    }
  }

  /// Clears the current proposal and resets state.
  void clear() {
    cache = _proposalCache.copyWithoutProposal();
    emit(const ProposalViewerState());
  }

  @override
  Future<void> close() async {
    await _proposalSub?.cancel();
    _proposalSub = null;
    return super.close();
  }

  @override
  void dismissCollaboratorBanner() {
    emit(state.copyWith(collaborator: const NoneCollaboratorProposalState()));
  }

  Future<void> loadProposal(DocumentRef id) async {
    return super.loadDocument(id);
  }

  @override
  Future<void> rejectCollaboratorInvitation() async {
    try {
      await super.rejectCollaboratorInvitation();

      if (!isClosed) {
        emit(state.copyWith(collaborator: const RejectedCollaboratorInvitationState()));
      }
    } catch (error) {
      if (!isClosed) {
        emitError(LocalizedException.create(error));
      }
    }
  }

  @override
  Future<void> rejectFinalProposal() async {
    try {
      await super.rejectFinalProposal();

      if (!isClosed) {
        emit(state.copyWith(collaborator: const RejectedCollaboratorFinalProposalConsentState()));
      }
    } catch (error) {
      if (!isClosed) {
        emitError(LocalizedException.create(error));
      }
    }
  }

  @override
  Future<DocumentRef> resolveToLatestVersion(DocumentRef id) async {
    return proposalService.getLatestProposalVersion(id: id);
  }

  @override
  Future<void> retryLastRef() async {
    final id = cache.id;

    if (id != null) {
      return loadProposal(id);
    }
  }

  @override
  Future<void> syncAndWatchDocument() async {
    // Cancel existing subscription
    await _proposalSub?.cancel();
    _proposalSub = null;

    // Sync the proposal data first
    await _syncProposal();

    // Then watch for updates
    if (!isClosed) {
      _watchProposal();
    }
  }

  @override
  Future<void> updateIsFavorite({required bool value}) async {
    final id = cache.id;
    assert(id != null, 'Proposal id not found. Load doc first');

    // Update cache optimistically
    cache = _proposalCache.copyWithIsFavorite(value: value);
    _rebuildState();

    // Update via service
    try {
      if (value) {
        await proposalService.addFavoriteProposal(id: id!);
      } else {
        await proposalService.removeFavoriteProposal(id: id!);
      }
    } catch (error, stackTrace) {
      _logger.severe('Failed to update favorite status', error, stackTrace);
      // Rollback on error
      cache = _proposalCache.copyWithIsFavorite(value: !value);
      if (!isClosed) {
        _rebuildState();
        emitError(LocalizedException.create(error));
      }
    }
  }

  /// Builds the proposal view data from cache.
  DocumentViewData _buildProposalViewData() {
    final proposalData = _proposalCache.proposalData;
    final proposal = proposalData?.proposalOrDocument.asProposalDocument;

    if (proposal == null) {
      return const DocumentViewData();
    }

    final proposalDocumentRef = proposal.metadata.id;

    // Build segments from proposal document
    final segments = mapDocumentToSegments(proposal.document);

    final header = DocumentViewHeader(
      title: proposal.title ?? '',
      authorName: proposal.authorName,
      createdAt: proposalDocumentRef.ver?.tryDateTime,
    );

    return DocumentViewData(
      header: header,
      segments: segments,
    );
  }

  /// Handles changes to proposal data.
  void _handleProposalData(ProposalDataV2? data) {
    final proposalDataChanged = _proposalCache.proposalData != data;
    final proposalIdChanged = _proposalCache.proposalData?.id != data?.id;

    cache = _proposalCache.copyWith(proposalData: Optional(data));

    if (proposalIdChanged) {
      // Proposal changed - update collaborator state
      _handleProposalVersionSignal();
    }

    if (proposalDataChanged) {
      _rebuildState();
    }
  }

  /// Emits signals based on proposal version being viewed.
  void _handleProposalVersionSignal() {
    if (state.isLoading || _isViewingLatestVersion) {
      return;
    }

    final proposalCampaign = _proposalCache.proposalData?.proposalOrDocument.campaign;
    final isVotingStage = _isVotingStage(proposalCampaign);

    if (isVotingStage && cache.activeAccountId != null) {
      emitSignal(const ViewingOlderVersionWhileVotingSignal());
    } else {
      emitSignal(const ViewingOlderVersionSignal());
    }
  }

  /// Checks if voting stage is active.
  bool _isVotingStage(Campaign? campaign) {
    if (!featureFlagsService.isEnabled(Features.voting)) return false;
    return campaign?.isVotingStateActive ?? false;
  }

  /// Rebuilds the state from the cache.
  void _rebuildState() {
    final proposalData = _proposalCache.proposalData;

    final proposalCampaign = proposalData?.proposalOrDocument.campaign;
    final submissionPhase = proposalCampaign?.phaseStateTo(
      CampaignPhaseType.proposalSubmission,
    );
    final isReadOnlyMode = submissionPhase?.status.isPost ?? true;

    final activeAccountId = cache.activeAccountId;
    final collaborators = proposalData?.collaborators ?? const <ProposalDataCollaborator>[];
    final collaboratorsState = CollaboratorProposalState.fromCollaboratorData(
      collaborators: collaborators,
      activeAccountId: activeAccountId,
      isFinal: proposalData?.publish.isPublished ?? false,
    );

    final viewData = _buildProposalViewData();

    emit(
      state.copyWith(
        data: viewData,
        collaborator: collaboratorsState,
        readOnlyMode: isReadOnlyMode,
      ),
    );
  }

  /// Synchronizes proposal data from the service.
  Future<void> _syncProposal() async {
    final id = cache.id;
    if (id == null) {
      return;
    }

    emit(state.copyWith(isLoading: true, error: const Optional.empty()));
    try {
      final activeAccountId = cache.activeAccountId;
      final proposal = await proposalService.getProposalV2(
        id: id,
        activeAccount: activeAccountId,
      );

      if (isClosed) return;

      _validateProposalData(proposal);
      _handleProposalData(proposal);
    } catch (error, stack) {
      _logger.severe('Synchronizing proposal($id) failed', error, stack);
      if (!isClosed) {
        emit(
          state.copyWith(error: Optional(LocalizedException.create(error))),
        );
      }
    } finally {
      if (!isClosed) {
        emit(state.copyWith(isLoading: false));
      }
    }
  }

  /// Validates proposal data before processing.
  void _validateProposalData(ProposalDataV2? data) {
    if (data == null) {
      throw const LocalizedNotFoundException();
    }

    if (data.isHidden) {
      throw const LocalizedNotFoundException();
    }

    if (!data.proposalOrDocument.isProposal) {
      throw const LocalizedProposalTemplateNotFoundException();
    }
  }

  /// Watches for proposal updates via stream.
  void _watchProposal() {
    final id = cache.id;
    final activeAccountId = cache.activeAccountId;

    final stream = id != null
        ? proposalService.watchProposal(id: id, activeAccount: activeAccountId)
        : Stream<ProposalDataV2?>.value(null);

    unawaited(_proposalSub?.cancel());
    _proposalSub = stream.distinct().listen(_handleProposalData);
  }
}
