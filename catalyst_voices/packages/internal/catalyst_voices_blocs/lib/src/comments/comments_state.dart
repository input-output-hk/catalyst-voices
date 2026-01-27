import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class CommentsState extends Equatable {
  final DocumentCommentsSort commentsSort;
  final Map<DocumentRef, bool> showReplies;
  final Map<DocumentRef, bool> showReplyBuilder;

  const CommentsState({
    this.commentsSort = DocumentCommentsSort.newest,
    this.showReplies = const {},
    this.showReplyBuilder = const {},
  });

  @override
  List<Object?> get props => [
    commentsSort,
    showReplies,
    showReplyBuilder,
  ];

  CommentsState copyWith({
    DocumentCommentsSort? commentsSort,
    Map<DocumentRef, bool>? showReplies,
    Map<DocumentRef, bool>? showReplyBuilder,
  }) {
    return CommentsState(
      commentsSort: commentsSort ?? this.commentsSort,
      showReplies: showReplies ?? this.showReplies,
      showReplyBuilder: showReplyBuilder ?? this.showReplyBuilder,
    );
  }

  CommentsState updateCommentBuilder({
    required SignedDocumentRef ref,
    required bool show,
  }) {
    final updatedBuilders = Map.of(showReplyBuilder);
    updatedBuilders[ref] = show;
    return copyWith(showReplyBuilder: updatedBuilders);
  }

  CommentsState updateCommentReplies({
    required SignedDocumentRef ref,
    required bool show,
  }) {
    final updatedReplies = Map.of(showReplies);
    updatedReplies[ref] = show;
    return copyWith(showReplies: updatedReplies);
  }
}
