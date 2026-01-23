import 'dart:async';

import 'package:catalyst_voices_blocs/src/document_viewer/cache/document_viewer_cache.dart';
import 'package:catalyst_voices_blocs/src/document_viewer/document_viewer_cubit.dart';
import 'package:catalyst_voices_blocs/src/document_viewer/document_viewer_state.dart';
import 'package:catalyst_voices_blocs/src/document_viewer/interfaces/document_viewer_comments.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/foundation.dart';

final _logger = Logger('DocumentViewerCommentsMixin');

/// Mixin providing comments functionality for document viewers.
///
/// This mixin provides protected methods that handle comment business logic
/// (cache manipulation, service calls) but do NOT emit state. The cubit that uses
/// this mixin is responsible for orchestrating these methods and emitting state.
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

  /// Protected method to cancel the comments subscription.
  @protected
  Future<void> cancelCommentsWatch() async {
    await _commentsSub?.cancel();
    _commentsSub = null;
  }

  Future<void> fetchCommentTemplate();

  /// Submits a comment or reply to the document.
  ///
  /// This is the public API that must be implemented by subclasses.
  /// Implementations should call [submitCommentInternal] and handle state emission.
  @override
  Future<void> submitComment({
    required Document document,
    SignedDocumentRef? reply,
  });

  /// Protected internal method that handles comment submission business logic.
  ///
  /// This method:
  /// - Validates the cache state
  /// - Creates the comment document
  /// - Updates the cache optimistically
  /// - Calls [onOptimisticUpdate] to rebuild state
  /// - Calls the comment service
  /// - Rolls back on error by rethrowing
  ///
  /// Subclasses should call this from [submitComment] and handle state emission.
  @protected
  Future<void> submitCommentInternal({
    required Document document,
    SignedDocumentRef? reply,
    required VoidCallback onOptimisticUpdate,
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
    onOptimisticUpdate();

    final documentData = comment.toDocumentData(mapper: documentMapper);

    try {
      await commentService.submitComment(document: documentData);
    } catch (error, stack) {
      _logger.info('Publishing comment failed', error, stack);

      // Rollback cache on error
      final source = cache.comments;
      final comments = (source ?? []).removeComment(ref: commentRef);
      cache = cache.copyWith(comments: Optional(comments));

      rethrow;
    }
  }

  /// Updates the visibility of a comment reply builder (input form).
  ///
  /// This is a UI state management method that must be implemented by the cubit
  /// to show/hide reply input forms for specific comments.
  ///
  /// Implementation should update the state to reflect the builder visibility.
  @override
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
  @override
  void updateCommentReplies({
    required SignedDocumentRef ref,
    required bool show,
  });

  /// Updates the sorting order of comments.
  ///
  /// This is a UI state management method that must be implemented by the cubit
  /// to change how comments are sorted (e.g., newest first, oldest first).
  @override
  void updateCommentsSort({required DocumentCommentsSort sort});

  @override
  Future<void> updateUsername(String value);

  Future<void> updateUsernameInternal(String value) async {
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
    } catch (error, stack) {
      _logger.info('Updating username failed', error, stack);
      rethrow;
    }
  }

  /// Protected method to watch comments on the current document.
  ///
  /// This sets up a subscription to watch for comment changes and updates the cache.
  /// The provided [onCommentsChanged] callback is called when comments change,
  /// allowing the cubit to rebuild state.
  @protected
  void watchComments({
    required void Function(List<CommentWithReplies>) onCommentsChanged,
  }) {
    final id = cache.id;

    final stream = id != null && id.isSigned
        ? commentService.watchCommentsWith(ref: id as SignedDocumentRef)
        : Stream.value(const <CommentWithReplies>[]);

    unawaited(_commentsSub?.cancel());
    _commentsSub = stream.listen((comments) {
      cache = cache.copyWith(comments: Optional(comments));
      onCommentsChanged(comments);
    });
  }
}
