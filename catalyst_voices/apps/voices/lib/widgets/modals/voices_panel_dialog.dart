import 'dart:async';

import 'package:catalyst_voices/widgets/buttons/voices_buttons.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class VoicesPanelDialog extends StatelessWidget {
  final BoxConstraints constraints;
  final EdgeInsets insetPadding;
  final Color? backgroundColor;
  final bool showBorder;
  final bool showClose;
  final Widget child;

  const VoicesPanelDialog({
    super.key,
    this.constraints = const BoxConstraints(
      minWidth: 648,
      maxWidth: 648,
      minHeight: 256,
    ),
    this.insetPadding = const EdgeInsets.symmetric(horizontal: 40, vertical: 90),
    this.backgroundColor,
    this.showBorder = false,
    this.showClose = true,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // TODO(dt-iohk): remove SelectionArea when https://github.com/flutter/flutter/pull/167275
    // is released and we're using this flutter version
    // Note: fix scheduled for 3.34.x / 3.35.x flutter version
    return SelectionArea(
      child: ResponsiveBuilder.fromState(
        responsiveState: constraints.toResponsive(),
        builder: (context, constraints) {
          return Dialog(
            shape: showBorder
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Theme.of(context).colors.outlineBorderVariant,
                    ),
                  )
                : Theme.of(context).dialogTheme.shape,
            backgroundColor: backgroundColor,
            alignment: Alignment.center,
            insetPadding: insetPadding,
            constraints: constraints,
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                child,
                Positioned(
                  top: 0,
                  right: 0,
                  child: Offstage(
                    offstage: !showClose,
                    child: const _CloseButton(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  const _CloseButton();

  @override
  Widget build(BuildContext context) {
    const buttonStyle = ButtonStyle(
      fixedSize: WidgetStatePropertyAll(Size.square(48)),
    );

    return IconButtonTheme(
      data: const IconButtonThemeData(style: buttonStyle),
      child: XButton(
        key: const Key('DialogCloseButton'),
        onTap: () {
          unawaited(Navigator.of(context).maybePop());
        },
      ),
    );
  }
}
