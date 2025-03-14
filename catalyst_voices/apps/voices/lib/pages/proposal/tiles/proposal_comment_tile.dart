import 'package:catalyst_voices/widgets/widgets.dart';
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
    final uri = Uri.parse(
      'id.catalyst://cardano/FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE',
    );
    final catId = CatalystId.fromUri(uri);

    return DecoratedBox(
      decoration: BoxDecoration(border: Border.all()),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileContainer(profile: Profile(catalystId: catId)),
          for (final property in comment.comment.document.properties)
            DocumentPropertyReadBuilder(property: property),
        ],
      ),
    );
  }
}
