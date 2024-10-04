import 'package:catalyst_voices/widgets/tooltips/voices_plain_tooltip.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

/// Widget that is meant to be used as singular keyboard key indication.
///
/// Common use case is to show list of such keys that together means
/// shortcut of some sorts.
///
/// See:
///   * [VoicesPlainTooltip] as good starting points for used of this button.
class VoicesKeyboardKeyButton extends StatelessWidget {
  /// Usually [Icon], [CatalystSvgIcon] or [Text].
  final Widget child;

  const VoicesKeyboardKeyButton({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final iconTheme = IconThemeData(
      size: 14,
      color: theme.colors.iconsForeground,
    );

    final textStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      height: 1,
      color: theme.colors.textPrimary,
    );

    return IconTheme(
      data: iconTheme,
      child: DefaultTextStyle(
        style: textStyle,
        textAlign: TextAlign.center,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 23.3, minHeight: 23.3),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4.6),
              color: const Color(0xFFD9D9D9),
            ),
            child: Container(
              margin: const EdgeInsets.only(
                left: 2.3,
                top: 1.17,
                right: 2.3,
                bottom: 3.5,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(2.3),
              ),
              alignment: Alignment.center,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
