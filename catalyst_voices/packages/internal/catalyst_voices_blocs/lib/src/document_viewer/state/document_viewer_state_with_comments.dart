import 'package:catalyst_voices_blocs/src/comments/comments_state.dart';

/// State marker interface for states that support comments functionality.
/// States implementing this interface can be used with widgets that need comments support.
abstract class DocumentViewerStateWithComments {
  /// The comments state containing sort, showReplies, and showReplyBuilder.
  CommentsState get comments;
}
