import 'package:catalyst_voices/widgets/buttons/voices_buttons.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class VoicesAlignTitleHeader extends StatelessWidget {
  final String title;
  final TextStyle? titleStyle;
  final EdgeInsets? padding;

  const VoicesAlignTitleHeader({
    super.key,
    required this.title,
    this.padding,
    this.titleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: titleStyle ?? Theme.of(context).textTheme.titleMedium,
          ),
          const _CloseButton(),
        ],
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colors;

    final style = IconButton.styleFrom(
      backgroundColor: colors.iconsBackground,
      foregroundColor: colors.iconsForeground,
    );

    return IconButtonTheme(
      data: IconButtonThemeData(style: style),
      child: XButton(
        onTap: () async => Navigator.of(context).maybePop(),
      ),
    );
  }
}
