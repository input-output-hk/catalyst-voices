import 'package:catalyst_voices/widgets/comment/document_comment_with_replies_card.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class DocumentCommentTile extends StatelessWidget {
  final CommentWithReplies comment;
  final bool canReply;

  const DocumentCommentTile({
    super.key,
    required this.comment,
    required this.canReply,
  });

  @override
  Widget build(BuildContext context) {
    final showReplies = context.select<DocumentViewerCubit, Map<DocumentRef, bool>>((value) {
      return switch (value.state) {
        DocumentViewerStateWithComments(:final comments) => comments.showReplies,
        _ => const {},
      };
    });

    final showReplyBuilder = context.select<DocumentViewerCubit, bool>((value) {
      return switch (value.state) {
        DocumentViewerStateWithComments(:final comments) =>
          comments.showReplyBuilder[comment.ref] ?? false,
        _ => false,
      };
    });

    final id = comment.comment.metadata.id.id;
    final baseCubit = context.read<DocumentViewerCubit>();

    assert(
      baseCubit is DocumentViewerCommentsMixin,
      'DocumentCommentTile requires a cubit with DocumentViewerCommentsMixin',
    );

    final cubit = baseCubit as DocumentViewerCommentsMixin;

    return DocumentCommentWithRepliesCard(
      key: ValueKey('DocumentComment.$id.WithReplies'),
      comment: comment,
      canReply: canReply,
      showReplies: showReplies,
      showReplyBuilder: showReplyBuilder,
      onSubmit: ({required document, reply}) async {
        return cubit.submitComment(document: document, reply: reply);
      },
      onCancel: () {
        cubit.updateCommentBuilder(ref: comment.ref, show: false);
      },
      onToggleBuilder: (show) {
        cubit.updateCommentBuilder(ref: comment.ref, show: show);
      },
      onToggleReplies: (show) {
        cubit.updateCommentReplies(ref: comment.ref, show: show);
      },
    );
  }
}
