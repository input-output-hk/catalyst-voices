import 'package:catalyst_voices/widgets/comment/document_comment_builder.dart';
import 'package:catalyst_voices/widgets/comment/document_comment_pick_username_tile.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class DocumentAddCommentTile extends StatelessWidget {
  final DocumentSchema schema;
  final bool showUsernameRequired;
  final OnSubmitDocumentComment onSubmit;
  final ValueChanged<String> onUsernamePicked;

  const DocumentAddCommentTile({
    super.key,
    required this.schema,
    required this.showUsernameRequired,
    required this.onSubmit,
    required this.onUsernamePicked,
  });

  @override
  Widget build(BuildContext context) {
    if (showUsernameRequired) {
      return DocumentCommentPickUsernameTile(
        onUsernamePicked: onUsernamePicked,
      );
    }
    return DocumentCommentBuilder(
      schema: schema,
      onSubmit: onSubmit,
    );
  }
}
