import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final Widget? leading;
  final Widget title;
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

    return IconButtonTheme(
      data: const IconButtonThemeData(
        style: ButtonStyle(
          fixedSize: WidgetStatePropertyAll(Size.square(48)),
        ),
      ),
      child: DefaultTextStyle(
        style: (theme.textTheme.titleSmall ?? const TextStyle())
            .copyWith(color: theme.colors.textOnPrimary),
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
