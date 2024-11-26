import 'package:catalyst_voices/widgets/buttons/voices_buttons.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class VoicesDetailsDialogHeader extends StatelessWidget {
  final String title;
  final String titleLabel;

  const VoicesDetailsDialogHeader({
    super.key,
    required this.title,
    required this.titleLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Later this upper constraints may change
      constraints: const BoxConstraints(minHeight: 166, maxHeight: 166),
      padding: const EdgeInsets.all(12).add(const EdgeInsets.only(bottom: 4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: _CloseButton(),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TitleLabelText(titleLabel),
                _TitleText(title),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleLabelText extends StatelessWidget {
  final String data;

  const _TitleLabelText(this.data);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colors = theme.colors;

    return Text(
      data,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: textTheme.titleSmall
          ?.copyWith(color: colors.elevationsOnSurfaceNeutralLv1Grey),
    );
  }
}

class _TitleText extends StatelessWidget {
  final String data;

  const _TitleText(this.data);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colors = theme.colors;

    return Text(
      data,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: textTheme.displayMedium?.copyWith(
        color: colors.textOnPrimary,
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
