import 'package:catalyst_voices/widgets/comment/document_comment_with_replies_card.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class ProposalBuilderCommentTile extends StatelessWidget {
  final CommentWithReplies comment;
  final bool canReply;

  const ProposalBuilderCommentTile({
    super.key,
    required this.comment,
    required this.canReply,
  });

  @override
  Widget build(BuildContext context) {
    final showReplies = context.select<ProposalBuilderBloc, Map<DocumentRef, bool>>((value) {
      return value.state.comments.showReplies;
    });

    final showReplyBuilder = context.select<ProposalBuilderBloc, bool>((value) {
      return value.state.comments.showReplyBuilder[comment.ref] ?? false;
    });

    final id = comment.comment.metadata.id.id;
    final bloc = context.read<ProposalBuilderBloc>();

    return DocumentCommentWithRepliesCard(
      key: ValueKey('DocumentComment.$id.WithReplies'),
      comment: comment,
      canReply: canReply,
      showReplies: showReplies,
      showReplyBuilder: showReplyBuilder,
      onSubmit: ({required document, reply}) async {
        final event = SubmitCommentEvent(
          document: document,
          reply: reply,
        );
        bloc.add(event);
      },
      onCancel: () {
        bloc.add(UpdateCommentBuilderEvent(ref: comment.ref, show: false));
      },
      onToggleBuilder: (show) {
        bloc.add(UpdateCommentBuilderEvent(ref: comment.ref, show: show));
      },
      onToggleReplies: (show) {
        bloc.add(UpdateCommentRepliesEvent(ref: comment.ref, show: show));
      },
    );
  }
}
