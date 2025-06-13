import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';

final class CommentsState extends Equatable {
  final ProposalCommentsSort commentsSort;
  final Map<DocumentRef, bool> showReplies;
  final Map<DocumentRef, bool> expandComment;
  final Map<DocumentRef, bool> showReplyBuilder;

  const CommentsState({
    this.commentsSort = ProposalCommentsSort.newest,
    this.showReplies = const {},
    this.expandComment = const {},
    this.showReplyBuilder = const {},
  });

  @override
  List<Object?> get props => [
        commentsSort,
        showReplies,
        expandComment,
        showReplyBuilder,
      ];

  CommentsState copyWith({
    ProposalCommentsSort? commentsSort,
    Map<DocumentRef, bool>? showReplies,
    Map<DocumentRef, bool>? expandComment,
    Map<DocumentRef, bool>? showReplyBuilder,
  }) {
    return CommentsState(
      commentsSort: commentsSort ?? this.commentsSort,
      showReplies: showReplies ?? this.showReplies,
      expandComment: expandComment ?? this.expandComment,
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

  CommentsState updateCommentExpand({
    required SignedDocumentRef ref,
    required bool isExpanded,
  }) {
    final updatedExpandComment = Map.of(expandComment);
    updatedExpandComment[ref] = isExpanded;
    return copyWith(showReplies: updatedExpandComment);
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
