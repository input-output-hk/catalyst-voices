import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/document/document_to_segment_mixin.dart';
import 'package:catalyst_voices_blocs/src/document_viewer/cache/document_viewer_cache.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

abstract base class DocumentViewerCubit<
  S extends DocumentViewerState,
  Cache extends DocumentViewerCache<Cache>
>
    extends Cubit<S>
    with
        BlocErrorEmitterMixin,
        BlocSignalEmitterMixin<DocumentViewerSignal, S>,
        DocumentToSegmentMixin {
  @protected
  final ProposalService proposalService;

  @protected
  final UserService userService;

  @protected
  final DocumentMapper documentMapper;

  @protected
  final FeatureFlagsService featureFlagsService;

  @protected
  Cache cache;

  StreamSubscription<CatalystId?>? _activeAccountIdSub;

  /// Protected subscription for watching document changes.
  /// Subclasses should manage this subscription in their syncAndWatchDocument implementation.
  @protected
  StreamSubscription<DocumentData?>? documentSub;

  DocumentViewerCubit(
    this.proposalService,
    this.userService,
    this.documentMapper,
    this.featureFlagsService, {
    required S initialState,
    required this.cache,
  }) : super(initialState);

  /// Checks if viewing the latest version of the document.
  @protected
  bool get isViewingLatestVersion {
    final versions = getDocumentVersions();
    if (versions.isEmpty) return true;

    final currentVersion = cache.id?.ver;
    final latestVersion = versions.last.ver;
    return currentVersion == latestVersion;
  }

  @override
  @mustCallSuper
  Future<void> close() async {
    await _activeAccountIdSub?.cancel();
    _activeAccountIdSub = null;

    await documentSub?.cancel();
    documentSub = null;

    return super.close();
  }

  /// Returns the list of document versions.
  ///
  /// Subclasses implement this to provide version information from their cache.
  @protected
  List<DocumentRef> getDocumentVersions();

  /// Handles active account ID changes.
  ///
  /// Subclasses can override this to customize behavior when the active account changes.
  /// The default implementation updates the cache and triggers a document reload.
  @protected
  void handleActiveAccountIdChanged(CatalystId? newAccountId) {
    final previousAccountId = cache.activeAccountId;
    if (previousAccountId == newAccountId) {
      return;
    }

    cache = cache.copyWith(activeAccountId: Optional(newAccountId));

    // If account changed significantly, reload the document
    if (!previousAccountId.isSameAs(newAccountId)) {
      unawaited(retryLastRef());
    }
  }

  /// Emits signals based on document version being viewed.
  ///
  /// Called when the document changes to notify the UI about version state.
  /// Emits:
  /// - [ViewingOlderVersionWhileVotingSignal] if viewing old version during voting
  /// - [ViewingOlderVersionSignal] if viewing old version otherwise
  @protected
  void handleDocumentVersionSignal() {
    if (isViewingLatestVersion) {
      return;
    }

    final isVoting = isVotingStage();
    final hasActiveAccount = cache.activeAccountId != null;

    if (isVoting && hasActiveAccount) {
      emitSignal(const ViewingOlderVersionWhileVotingSignal());
    } else {
      emitSignal(const ViewingOlderVersionSignal());
    }
  }

  /// Initializes the cubit with subscriptions and cache setup.
  @mustCallSuper
  void init() {
    // Initialize cache with active account ID
    cache = cache.copyWith(
      activeAccountId: Optional(userService.user.activeAccount?.catalystId),
    );

    // Watch for active account changes
    _setupActiveAccountIdSubscription();
  }

  /// Returns whether the document is in voting stage.
  ///
  /// Subclasses implement this to check if voting is active for the document.
  @protected
  bool isVotingStage();

  /// Loads a document by reference.
  ///
  /// This template method coordinates the document loading flow:
  /// 1. Validates the document reference
  /// 2. Resolves loose references to concrete versions
  /// 3. Updates cache with the resolved reference
  /// 4. Syncs and watches the document for changes
  ///
  /// Subclasses implement type-specific behavior via protected abstract methods.
  /// Do not override this method - override the protected methods instead.
  Future<void> loadDocument(DocumentRef id) async {
    if (!id.isValid) {
      emit(state.copyWith(error: const Optional(LocalizedDocumentReferenceException())) as S);
      return;
    }

    // Resolve to concrete version if needed
    final effectiveRef = id.isLoose ? await resolveToLatestVersion(id) : id;
    if (isClosed) return;

    cache = cache.copyWith(id: Optional(effectiveRef));

    // Sync and watch
    await syncAndWatchDocument();
  }

  /// Resolves a loose document reference to its latest version.
  ///
  /// Subclasses implement this to call their specific service method.
  /// Example: ProposalViewerCubit calls proposalService.getLatestProposalVersion()
  @protected
  Future<DocumentRef> resolveToLatestVersion(DocumentRef id);

  Future<void> retryLastRef();

  /// Synchronizes the document from the service and watches for updates.
  ///
  /// Subclasses implement this to:
  /// 1. Cancel existing subscriptions
  /// 2. Fetch document data from their service
  /// 3. Validate and handle the data
  /// 4. Set up watchers for real-time updates
  @protected
  Future<void> syncAndWatchDocument();

  Future<void> updateIsFavorite({required bool value});

  /// Sets up the subscription for active account ID changes.
  void _setupActiveAccountIdSubscription() {
    _activeAccountIdSub = userService.watchUnlockedActiveAccount
        .map((activeAccount) => activeAccount?.catalystId)
        .distinct()
        .listen(handleActiveAccountIdChanged);
  }
}
