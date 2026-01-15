import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/document/document_to_segment_mixin.dart';
import 'package:catalyst_voices_blocs/src/document_viewer/cache/document_viewer_cache.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

abstract base class DocumentViewerCubit<S extends DocumentViewerState> extends Cubit<S>
    with BlocErrorEmitterMixin, DocumentToSegmentMixin {
  @protected
  final ProposalService proposalService;

  @protected
  final UserService userService;

  @protected
  final DocumentMapper documentMapper;

  @protected
  final FeatureFlagsService featureFlagsService;

  @protected
  DocumentViewerCache cache = DocumentViewerCache();

  StreamSubscription<CatalystId?>? _activeAccountIdSub;

  DocumentViewerCubit(
    super.initialState,
    this.proposalService,
    this.userService,
    this.documentMapper,
    this.featureFlagsService,
  ) {
    // Initialize cache with active account ID
    cache = cache.copyWith(
      activeAccountId: Optional(userService.user.activeAccount?.catalystId),
    );

    // Watch for active account changes
    _activeAccountIdSub = userService.watchUnlockedActiveAccount
        .map((activeAccount) => activeAccount?.catalystId)
        .distinct()
        .listen(handleActiveAccountIdChanged);
  }

  @override
  @mustCallSuper
  Future<void> close() async {
    await _activeAccountIdSub?.cancel();
    _activeAccountIdSub = null;
    return super.close();
  }

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
}
