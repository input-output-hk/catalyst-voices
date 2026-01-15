import 'dart:async';

import 'package:catalyst_voices_blocs/src/document_viewer/cache/document_viewer_comments_cache.dart';
import 'package:catalyst_voices_blocs/src/document_viewer/document_viewer_cubit.dart';
import 'package:catalyst_voices_blocs/src/document_viewer/document_viewer_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/foundation.dart';

final _logger = Logger('DocumentViewerCommentsMixin');

/// Mixin providing comments functionality for document viewers.
///
/// This mixin provides protected  methods that handle comment business logic
/// (cache manipulation, service calls) but do NOT emit state. The cubit that uses
/// this mixin is responsible for orchestrating these methods and emitting state.
///
/// The cache must implement [DocumentViewerCommentsCache] to use this mixin.
base mixin DocumentViewerCommentsMixin<S extends DocumentViewerState> on DocumentViewerCubit<S> {
  StreamSubscription<List<CommentWithReplies>>? _commentsSub;

  CommentService get commentService;

  /// Returns the cache as [DocumentViewerCommentsCache].
  /// Asserts in debug mode that the cache implements the correct type.
  DocumentViewerCommentsCache get _commentsCache {
    assert(
      cache is DocumentViewerCommentsCache,
      'Cache must implement DocumentViewerCommentsCache',
    );
    return cache as DocumentViewerCommentsCache;
  }

  /// Protected method to cancel the comments subscription.
  @protected
  @mustCallSuper
  Future<void> cancelCommentsWatch() async {
    await _commentsSub?.cancel();
    _commentsSub = null;
  }

  @override
  @mustCallSuper
  Future<void> close() async {
    await _commentsSub?.cancel();
    _commentsSub = null;
    return super.close();
  }

  /// Protected method for editing a comment (placeholder for future DRep feature).
  @protected
  @mustCallSuper
  Future<void> editComment({
    required Document document,
    SignedDocumentRef? reply,
  }) async {
    // To be implemented in DRep feature
    _logger.info('editComment not yet implemented');
  }

  @mustCallSuper
  Future<void> fetchCommentTemplate();

  /// Protected method to submit a comment.
  ///
  /// This method handles the business logic of submitting a comment:
  /// - Validates the cache state
  /// - Creates the comment document
  /// - Updates the cache optimistically
  /// - Calls the comment service
  /// - Rolls back on error by rethrowing
  ///
  /// The cubit should call this method and handle state emission.
  @protected
  @mustCallSuper
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

    final commentTemplate = _commentsCache.commentTemplate;
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
    final comments = (_commentsCache.comments ?? []).addComment(comment: comment);
    cache = _commentsCache.copyWithComments(comments);

    final documentData = comment.toDocumentData(mapper: documentMapper);

    try {
      await commentService.submitComment(document: documentData);
    } catch (error, stack) {
      _logger.info('Publishing comment failed', error, stack);

      // Rollback cache on error
      final source = _commentsCache.comments;
      final comments = (source ?? []).removeComment(ref: commentRef);
      cache = _commentsCache.copyWithComments(comments);

      rethrow;
    }
  }

  /// Updates the visibility of a comment reply builder (input form).
  ///
  /// This is a UI state management method that must be implemented by the cubit
  /// to show/hide reply input forms for specific comments.
  ///
  /// Implementation should update the state to reflect the builder visibility.
  void updateCommentBuilder({
    required SignedDocumentRef ref,
    required bool show,
  });

  /// Updates the visibility of comment replies (expand/collapse thread).
  ///
  /// This is a UI state management method that must be implemented by the cubit
  /// to expand or collapse reply threads for specific comments.
  ///
  /// Implementation should update the state to reflect the replies visibility.
  void updateCommentReplies({
    required SignedDocumentRef ref,
    required bool show,
  });

  /// Updates the sorting order of comments.
  ///
  /// This is a UI state management method that must be implemented by the cubit
  /// to change how comments are sorted (e.g., newest first, oldest first).
  ///
  // TODO(LynxLynxx): If all documents has the same comments sort then we should rename this parameter from ProposalCommentsSort to DocumentCommentsSort
  void updateCommentsSort({required ProposalCommentsSort sort});

  /// Protected method to watch comments on the current document.
  ///
  /// This sets up a subscription to watch for comment changes and updates the cache.
  /// The provided [onCommentsChanged] callback is called when comments change,
  /// allowing the cubit to rebuild state.
  @protected
  @mustCallSuper
  void watchComments({
    required void Function(List<CommentWithReplies>) onCommentsChanged,
  }) {
    final id = cache.id;

    final stream = id != null && id.isSigned
        ? commentService.watchCommentsWith(ref: id as SignedDocumentRef)
        : Stream.value(const <CommentWithReplies>[]);

    unawaited(_commentsSub?.cancel());
    _commentsSub = stream.listen((comments) {
      final c = _commentsCache;
      cache = c.copyWithComments(comments);
      onCommentsChanged(comments);
    });
  }
}
