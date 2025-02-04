import 'dart:async';

import 'package:catalyst_voices/widgets/buttons/voices_buttons.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

/// Commonly used structure for desktop dialogs.
///
/// Keep in mind that this dialog has fixed size of 900x600 and
/// is always adding close button in top right corner.
class VoicesSinglePaneDialog extends StatelessWidget {
  final BoxConstraints constraints;
  final Color? backgroundColor;
  final bool showBorder;
  final bool showClose;
  final Alignment closeAlignment;
  final Widget child;

  const VoicesSinglePaneDialog({
    super.key,
    this.constraints = const BoxConstraints(
      minWidth: 648,
      maxWidth: 648,
      minHeight: 256,
    ),
    this.backgroundColor,
    this.showBorder = false,
    this.showClose = true,
    this.closeAlignment = Alignment.topRight,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return _VoicesDesktopDialog(
      backgroundColor: backgroundColor,
      showBorder: showBorder,
      constraints: constraints,
      child: Stack(
        alignment: closeAlignment,
        children: [
          child,
          Offstage(
            offstage: !showClose,
            child: const _CloseButton(),
          ),
        ],
      ),
    );
  }
}

/// Commonly used structure for desktop dialogs.
///
/// Keep in mind that this dialog has fixed size of 900x600 and
/// is always adding close button in top right corner.
class VoicesTwoPaneDialog extends StatelessWidget {
  final Widget left;
  final Widget right;
  final bool showCloseButton;

  const VoicesTwoPaneDialog({
    super.key,
    required this.left,
    required this.right,
    this.showCloseButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return _VoicesDesktopDialog(
      constraints: const BoxConstraints.tightFor(width: 900, height: 600),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colors.elevationsOnSurfaceNeutralLv1Grey,
                  ),
                  child: left,
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: right,
                ),
              ),
            ],
          ),
          Offstage(
            offstage: !showCloseButton,
            child: const _CloseButton(),
          ),
        ],
      ),
    );
  }
}

class _VoicesDesktopDialog extends StatelessWidget {
  final BoxConstraints constraints;
  final Color? backgroundColor;
  final bool showBorder;
  final Widget child;

  const _VoicesDesktopDialog({
    required this.constraints,
    this.backgroundColor,
    this.showBorder = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
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
      alignment: Alignment.topCenter,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 90),
      child: ConstrainedBox(
        constraints: constraints,
        child: child,
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
