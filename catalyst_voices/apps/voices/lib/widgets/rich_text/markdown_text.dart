import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownText extends StatelessWidget with LaunchUrlMixin {
  final MarkdownData markdownData;
  final bool selectable;
  final Color? pColor;
  final TextStyle? pStyle;

  const MarkdownText(
    this.markdownData, {
    super.key,
    this.selectable = true,
    this.pColor,
    this.pStyle,
  });

  @override
  Widget build(BuildContext context) {
    final pColor = this.pColor;

    return MarkdownBody(
      data: markdownData.data,
      selectable: selectable,
      styleSheet: MarkdownStyleSheet(
        p: pStyle?.copyWith(color: pColor) ?? (pColor != null ? TextStyle(color: pColor) : null),
      ),
      onTapLink: (text, href, title) async {
        if (href != null) {
          await launchUri(href.getUri());
        }
      },
    );
  }
}
