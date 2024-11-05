import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

/// Reusable header widget. Common use case it to have [Text] as [title]
/// and [VoicesIconButton] as [leading] or [trailing].
class SectionHeader extends StatelessWidget {
  /// Leading widget, typically a button or icon.
  final Widget? leading;

  /// Title of the section.
  final Widget title;

  /// Creates a new SectionHeader widget.
  final List<Widget> trailing;

  const SectionHeader({
    super.key,
    this.leading,
    required this.title,
    this.trailing = const <Widget>[],
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    const iconButtonStyle = ButtonStyle(
      fixedSize: WidgetStatePropertyAll(Size.square(48)),
    );

    final textStyle = (theme.textTheme.titleSmall ?? const TextStyle())
        .copyWith(color: theme.colors.textOnPrimary);

    return IconButtonTheme(
      data: const IconButtonThemeData(style: iconButtonStyle),
      child: DefaultTextStyle(
        style: textStyle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        child: Container(
          constraints: const BoxConstraints.tightFor(height: 56),
          padding: const EdgeInsets.symmetric(horizontal: 6)
              .add(const EdgeInsets.only(left: 6)),
          child: Row(
            children: [
              if (leading != null) leading!,
              Expanded(child: title),
              if (trailing.isNotEmpty) ...[
                const SizedBox(width: 12),
                ...trailing,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
