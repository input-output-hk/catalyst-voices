import 'package:catalyst_voices/pages/proposal/widget/proposal_comment_builder.dart';
import 'package:catalyst_voices/pages/proposal/widget/proposal_comment_with_replies_card.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProposalCommentTile extends StatelessWidget {
  final CommentWithReplies comment;
  final bool canReply;
  final OnSubmitProposalComment onSubmit;
  final VoidCallback onCancel;
  final ValueChanged<bool> onToggleReply;

  const ProposalCommentTile({
    super.key,
    required this.comment,
    required this.canReply,
    required this.onSubmit,
    required this.onCancel,
    required this.onToggleReply,
  });

  @override
  Widget build(BuildContext context) {
    final showReplies = context.select<ProposalCubit, bool>((value) {
      return value.state.comments.showReplies[comment.ref] ?? true;
    });

    final showReplyBuilder = context.select<ProposalCubit, bool>((value) {
      return value.state.comments.showReplyBuilder[comment.ref] ?? false;
    });

    final id = comment.comment.metadata.selfRef.id;

    return ProposalCommentWithRepliesCard(
      key: ValueKey('ProposalComment.$id.WithReplies'),
      comment: comment,
      canReply: canReply,
      showReplies: showReplies,
      showReplyBuilder: showReplyBuilder,
      onSubmit: onSubmit,
      onCancel: onCancel,
      onToggleReply: onToggleReply,
    );
  }
}
