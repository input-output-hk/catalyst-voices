import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';

/// Interface for comment-related functionality in document viewers.
abstract interface class DocumentViewerComments {
  /// Submits a comment or reply to the document.
  Future<void> submitComment({
    required Document document,
    SignedDocumentRef? reply,
  });

  /// Updates the visibility of a comment reply builder (input form).
  void updateCommentBuilder({
    required SignedDocumentRef ref,
    required bool show,
  });

  /// Updates the visibility of comment replies (expand/collapse thread).
  void updateCommentReplies({
    required SignedDocumentRef ref,
    required bool show,
  });

  /// Updates the sorting order of comments.
  void updateCommentsSort({required DocumentCommentsSort sort});

  /// Updates the username for the active account.
  Future<void> updateUsername(String value);
}
