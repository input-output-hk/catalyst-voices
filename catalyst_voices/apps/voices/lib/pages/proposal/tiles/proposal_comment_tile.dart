import 'package:catalyst_voices/widgets/comment/proposal_comment_with_replies_card.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class ProposalCommentTile extends StatelessWidget {
  final CommentWithReplies comment;
  final bool canReply;

  const ProposalCommentTile({
    super.key,
    required this.comment,
    required this.canReply,
  });

  @override
  Widget build(BuildContext context) {
    final showReplies = context.select<ProposalCubit, Map<DocumentRef, bool>>((value) {
      return value.state.comments.showReplies;
    });

    final showReplyBuilder = context.select<ProposalCubit, bool>((value) {
      return value.state.comments.showReplyBuilder[comment.ref] ?? false;
    });

    final id = comment.comment.metadata.id.id;
    final cubit = context.read<ProposalCubit>();

    return ProposalCommentWithRepliesCard(
      key: ValueKey('ProposalComment.$id.WithReplies'),
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
