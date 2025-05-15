import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

/// Displays a list of bulleted points. Similar to <ul><li></li></ul> in html.
class BulletList extends StatelessWidget {
  /// The list of items without the bullet.
  final List<String> items;

  /// The text style applied to the bullet point and the [items].
  ///
  /// Defaults to Theme.of(context).textTheme.bodySmall,
  final TextStyle? style;

  /// The amount of vertical space between the [items].
  final double spacing;

  const BulletList({
    super.key,
    required this.items,
    this.style,
    this.spacing = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (final item in items)
          _BulletItem(
            text: item,
            style: style ??
                Theme.of(context).textTheme.bodySmall ??
                const TextStyle(),
          ),
      ].separatedBy(SizedBox(height: spacing)).toList(),
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;
  final TextStyle style;

  const _BulletItem({
    required this.text,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '• ',
          style: style,
        ),
        Flexible(
          child: DefaultTextStyle.merge(
            style: style,
            child: Text(text),
          ),
        ),
      ],
    );
  }
}
