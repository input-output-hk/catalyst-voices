import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class TipText extends StatelessWidget {
  final String data;
  final TextStyle? style;

  const TipText(
    this.data, {
    super.key,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return PlaceholderRichText(
      '${context.l10n.tip}: {content}',
      style: (style ?? const TextStyle()).copyWith(fontWeight: FontWeight.bold),
      placeholderSpanBuilder: (context, placeholder) {
        return switch (placeholder) {
          'content' => WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: MarkdownText(
                MarkdownData(data),
                pStyle: style,
              ),
            ),
          _ => throw ArgumentError('Unknown placeholder[$placeholder]'),
        };
      },
    );
  }
}
