import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class LabelDecorator extends StatelessWidget {
  /// An optional widget to display the label text next to the child.
  final Widget? label;

  /// An optional widget to display the note text next to the child.
  final Widget? note;

  /// The main content of the decorator.
  final Widget child;

  const LabelDecorator({
    super.key,
    this.label,
    this.note,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final label = this.label;
    final note = this.note;
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        if (label != null)
          Flexible(
            child: DefaultTextStyle(
              style: (theme.textTheme.bodyLarge ?? const TextStyle())
                  .copyWith(color: theme.colors.textPrimary),
              child: label,
            ),
          ),
        if (note != null)
          Flexible(
            child: DefaultTextStyle(
              style: (theme.textTheme.bodySmall ?? const TextStyle())
                  .copyWith(color: theme.colors.textOnPrimary),
              child: note,
            ),
          ),
      ].expandIndexed(
        (index, element) {
          return [
            if (index == 1) const SizedBox(width: 4),
            if (index == 2) const SizedBox(width: 8),
            element,
          ];
        },
      ).toList(),
    );
  }
}
