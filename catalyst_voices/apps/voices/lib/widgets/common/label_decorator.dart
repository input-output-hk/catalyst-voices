import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class LabelDecorator extends StatelessWidget {
  /// An optional widget to display the label text next to the child.
  final Widget? label;

  /// An optional widget to display the note text next to the child.
  final Widget? note;

  /// List of spacings to be. Index 0 is between child and next widget [label]
  /// or [note].
  final List<double> spacings;

  /// The main content of the decorator.
  final Widget child;

  const LabelDecorator({
    super.key,
    this.label,
    this.note,
    this.spacings = const [4, 8],
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
            if (index != 0)
              SizedBox(width: spacings.elementAtOrNull(index - 1)),
            element,
          ];
        },
      ).toList(),
    );
  }
}
