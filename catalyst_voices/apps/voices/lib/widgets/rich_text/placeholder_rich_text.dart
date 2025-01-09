import 'package:flutter/material.dart';

final _kPlaceholderRegExp = RegExp(r'{(\w*)}');

typedef PlaceholderSpanBuilder = InlineSpan Function(
  BuildContext context,
  String placeholder,
);

class PlaceholderRichText extends StatefulWidget {
  const PlaceholderRichText(
    this.text, {
    super.key,
    required this.placeholderSpanBuilder,
    this.style,
    this.textAlign = TextAlign.start,
  });

  final String text;
  final PlaceholderSpanBuilder placeholderSpanBuilder;
  final TextStyle? style;
  final TextAlign textAlign;

  @override
  State<PlaceholderRichText> createState() => _PlaceholderRichTextState();
}

class _PlaceholderRichTextState extends State<PlaceholderRichText> {
  List<InlineSpan> _spans = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Context colors may have changed, rebuild it.
    _spans = _calculateSpans();
  }

  @override
  void didUpdateWidget(covariant PlaceholderRichText oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.text != oldWidget.text) {
      _spans = _calculateSpans();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(children: _spans),
      textAlign: widget.textAlign,
      style: widget.style,
    );
  }

  List<InlineSpan> _calculateSpans() {
    final text = widget.text;
    final spans = <InlineSpan>[];

    text.splitMapJoin(
      _kPlaceholderRegExp,
      onMatch: (match) {
        final placeholder = match.group(0)!;
        // removes "{" and "}"
        final key = placeholder.substring(1, placeholder.length - 1);

        final span = widget.placeholderSpanBuilder(context, key);

        spans.add(span);

        return '';
      },
      onNonMatch: (match) {
        spans.add(TextSpan(text: match));
        return '';
      },
    );

    return spans;
  }
}
