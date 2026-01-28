import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/document_viewer/cache/document_viewer_cache.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';

final _logger = Logger('DocumentViewerCommentsMixin');

/// Mixin providing comments functionality for document viewers.
///
/// This mixin handles comment business logic including cache manipulation,
/// service calls, and state emission. Methods in this mixin may emit state
/// updates, errors, and signals directly.
///
/// Some methods are implemented with full business logic, while others are
/// abstract and must be implemented by the cubit using this mixin.
///
/// Accesses the comments and commentTemplate fields from the cache.
base mixin DocumentViewerCommentsMixin<
  State extends DocumentViewerState,
  Cache extends DocumentViewerCache<Cache>
>
    on DocumentViewerCubit<State, Cache>
    implements DocumentViewerComments {
  StreamSubscription<List<CommentWithReplies>>? _commentsSub;

  CommentService get commentService;

  @override
  Future<void> close() async {
    await _commentsSub?.cancel();
    _commentsSub = null;

    return super.close();
  }

  @override
  Future<void> fetchCommentTemplate();

  @override
  Future<void> submitComment({
    required Document document,
    SignedDocumentRef? reply,
  }) async {
    final proposalId = cache.id;
    assert(proposalId != null, 'Document ref not found. Load document first!');
    assert(
      proposalId != null && proposalId.isSigned,
      'Can comment only on signed documents',
    );

    final activeAccountId = cache.activeAccountId;
    assert(activeAccountId != null, 'No active account found!');

    final commentTemplate = cache.commentTemplate;
    assert(commentTemplate != null, 'No comment template found!');

    final documentParameters = cache.documentParameters;
    assert(documentParameters != null, 'Document parameters not found!');

    final commentRef = SignedDocumentRef.generateFirstRef();
    final comment = CommentDocument(
      metadata: CommentMetadata(
        id: commentRef,
        proposalRef: proposalId! as SignedDocumentRef,
        commentTemplate: commentTemplate!.metadata.id as SignedDocumentRef,
        reply: reply,
        parameters: documentParameters!,
        authorId: activeAccountId!,
      ),
      document: document,
    );

    // Optimistically update cache
    final comments = (cache.comments ?? []).addComment(comment: comment);
    cache = cache.copyWith(comments: Optional(comments));

    // Rebuild state immediately to show optimistic update
    rebuildState();

    final documentData = comment.toDocumentData(mapper: documentMapper);

    try {
      await commentService.submitComment(document: documentData);
    } catch (error, stack) {
      _logger.info('Publishing comment failed', error, stack);

      // Rollback cache on error
      final source = cache.comments;
      final comments = (source ?? []).removeComment(ref: commentRef);
      cache = cache.copyWith(comments: Optional(comments));

      if (!isClosed) {
        final localizedException = LocalizedException.create(error);
        emitError(localizedException);
        rebuildState();
      }
    }
  }

  @override
  Future<void> updateUsername(String value) async {
    final catId = cache.activeAccountId;
    if (catId == null) {
      _logger.warning('Tried to update username but no action account found');
      return;
    }

    try {
      await userService.updateAccount(
        id: catId,
        username: value.isNotEmpty ? Optional(value) : const Optional.empty(),
      );

      emitSignal(const UsernameUpdatedSignal());
    } catch (error, stack) {
      _logger.info('Updating username failed', error, stack);

      emitError(LocalizedException.create(error));
    }
  }

  @override
  void watchComments() {
    final id = cache.id;

    final stream = id != null && id.isSigned
        ? commentService.watchCommentsWith(ref: id as SignedDocumentRef)
        : Stream.value(const <CommentWithReplies>[]);

    unawaited(_commentsSub?.cancel());
    _commentsSub = stream.listen((comments) {
      cache = cache.copyWith(comments: Optional(comments));
      rebuildState();
    });
  }
}
