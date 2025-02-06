import 'package:catalyst_voices/widgets/buttons/voices_buttons.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
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
    return ConstrainedBox(
      // Later this upper constraints may change
      constraints: const BoxConstraints(minHeight: 166, maxHeight: 166),
      child: Stack(
        children: [
          const Positioned.fill(child: _Background()),
          _Foreground(titleLabel: titleLabel, title: title),
        ],
      ),
    );
  }
}

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    final asset = VoicesAssets.images.comingSoonBkg;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.black.withValues(alpha: 0),
            Colors.black.withValues(alpha: 0.4),
            Colors.black.withValues(alpha: 0.4),
          ],
          stops: const [
            0,
            0.7452,
            1,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      position: DecorationPosition.foreground,
      child: CatalystImage.asset(
        asset.path,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _Foreground extends StatelessWidget {
  final String titleLabel;
  final String title;

  const _Foreground({
    required this.titleLabel,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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

    return Text(
      data,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      // TODO(damian-molinski): Always using white colors without token.
      // Colors/sys color neutral md ref/N100
      style: textTheme.titleSmall?.copyWith(color: Colors.white),
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

    return Text(
      data,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      // TODO(damian-molinski): Always using white colors without token.
      // Colors/sys color neutral md ref/N100
      style: textTheme.displayMedium?.copyWith(color: Colors.white),
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
