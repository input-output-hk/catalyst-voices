import 'package:catalyst_voices/pages/proposal/widget/proposal_comment_with_replies_card.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class ProposalCommentTile extends StatelessWidget {
  final CommentWithReplies comment;

  const ProposalCommentTile({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return ProposalCommentWithRepliesCard(comment: comment);
  }
}
