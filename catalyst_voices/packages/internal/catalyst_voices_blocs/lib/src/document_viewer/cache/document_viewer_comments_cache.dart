import 'package:catalyst_voices_blocs/src/document_viewer/cache/document_viewer_cache.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';

/// Cache marker interface for caches that support comments functionality.
/// Caches implementing this interface can be used with DocumentViewerCommentsMixin.
abstract interface class DocumentViewerCommentsCache {
  /// The comments with their nested replies.
  List<CommentWithReplies>? get comments;

  /// The template defining the schema for comments.
  CommentTemplate? get commentTemplate;

  /// The document parameters (campaign, category, etc.).
  DocumentParameters? get documentParameters;

  /// Returns a copy of the cache with updated comments.
  DocumentViewerCache copyWithComments(List<CommentWithReplies>? comments);

  /// Returns a copy of the cache with updated comment template.
  DocumentViewerCache copyWithCommentTemplate(CommentTemplate? template);
}
