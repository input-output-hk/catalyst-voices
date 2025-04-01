import 'package:catalyst_voices/widgets/comment/proposal_comment_builder.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class ProposalAddCommentTile extends StatelessWidget {
  final DocumentSchema schema;
  final OnSubmitProposalComment onSubmit;

  const ProposalAddCommentTile({
    super.key,
    required this.schema,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return ProposalCommentBuilder(
      schema: schema,
      onSubmit: onSubmit,
    );
  }
}
