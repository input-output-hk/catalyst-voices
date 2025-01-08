import 'package:catalyst_voices/common/ext/ext.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownText extends StatelessWidget with LaunchUrlMixin {
  final MarkdownData markdownData;
  final bool selectable;
  const MarkdownText(
    this.markdownData, {
    super.key,
    this.selectable = true,
  });

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: markdownData.data,
      selectable: selectable,
      onTapLink: (text, href, title) async {
        if (href != null) {
          await launchHrefUrl(href.getUri());
        }
      },
    );
  }
}
