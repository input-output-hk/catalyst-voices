import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

/// Data for building comments segments.
///
/// This is a generic class that can be reused by any document viewer
/// that supports comments functionality.
final class CommentsSegmentData extends Equatable {
  /// The list of comments with their replies.
  final List<CommentWithReplies> comments;

  /// The schema for creating new comments.
  final DocumentSchema? commentSchema;

  /// The current sort order for comments.
  final DocumentCommentsSort commentsSort;

  /// The total count of comments (including replies), or null if comments aren't shown.
  final int? commentsCount;

  /// Whether the user can add new comments.
  final bool canComment;

  /// Whether the user can reply to comments.
  final bool canReply;

  const CommentsSegmentData({
    required this.comments,
    required this.commentSchema,
    required this.commentsSort,
    required this.commentsCount,
    required this.canComment,
    required this.canReply,
  });

  /// Creates [CommentsSegmentData] by computing permissions and counts.
  ///
  /// This factory method encapsulates the logic for determining comment
  /// permissions based on various factors.
  factory CommentsSegmentData.build({
    required List<CommentWithReplies> comments,
    required DocumentSchema? commentSchema,
    required DocumentCommentsSort commentsSort,
    required bool showComments,
    required bool hasActiveAccount,
    required bool hasAccountUsername,
    required bool isLocalDocument,
    required bool isVotingStage,
  }) {
    final commentsCount = showComments && !isLocalDocument
        ? comments.fold(0, (prev, next) => prev + 1 + next.repliesCount)
        : null;

    final isNotLocalAndHasActiveAccount = !isLocalDocument && hasActiveAccount;
    final canReply = isNotLocalAndHasActiveAccount && hasAccountUsername;
    final canComment =
        isNotLocalAndHasActiveAccount && commentSchema != null  && !isVotingStage;

    return CommentsSegmentData(
      comments: comments,
      commentSchema: commentSchema,
      commentsSort: commentsSort,
      commentsCount: commentsCount,
      canComment: canComment,
      canReply: canReply,
    );
  }

  bool get hasComments => comments.isNotEmpty;

  @override
  List<Object?> get props => [
    comments,
    commentSchema,
    commentsSort,
    commentsCount,
    canComment,
    canReply,
  ];

  /// Whether the comments segment should be shown at all.
  bool get shouldShowCommentsSegment => canComment || hasComments;
}
