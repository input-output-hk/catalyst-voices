import 'package:catalyst_voices/pages/proposal/widget/proposal_comment_builder.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class ProposalAddCommentTile extends StatelessWidget {
  final DocumentSchema schema;

  const ProposalAddCommentTile({
    super.key,
    required this.schema,
  });

  @override
  Widget build(BuildContext context) {
    return ProposalCommentBuilder(
      schema: schema,
    );
  }
}
