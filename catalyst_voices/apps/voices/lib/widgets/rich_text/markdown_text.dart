import 'package:catalyst_voices/common/codecs/markdown_to_plain_codec.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownText extends StatefulWidget {
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
  State<MarkdownText> createState() => _MarkdownTextState();
}

class _MarkdownTextState extends State<MarkdownText> with LaunchUrlMixin {
  late String _label;

  @override
  Widget build(BuildContext context) {
    final pColor = widget.pColor;

    return Semantics(
      identifier: 'MarkdownText',
      container: true,
      label: _label,
      child: ExcludeSemantics(
        child: MarkdownBody(
          data: widget.markdownData.data,
          selectable: widget.selectable,
          styleSheet: MarkdownStyleSheet(
            p:
                widget.pStyle?.copyWith(color: pColor) ??
                (pColor != null ? TextStyle(color: pColor) : null),
          ),
          onTapLink: (text, href, title) async {
            if (href != null) {
              await launchUri(href.getUri());
            }
          },
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(MarkdownText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.markdownData != widget.markdownData) {
      _convertLabel();
    }
  }

  @override
  void initState() {
    super.initState();

    _convertLabel();
  }

  void _convertLabel() {
    _label = const MarkdownToPlainStringEncoder().convert(widget.markdownData);
  }
}
