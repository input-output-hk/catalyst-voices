import 'package:catalyst_voices/widgets/buttons/voices_buttons.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class VoicesDesktopDialog extends StatelessWidget {
  final BoxConstraints constraints;
  final Widget child;

  const VoicesDesktopDialog({
    super.key,
    this.constraints = const BoxConstraints(minWidth: 900, minHeight: 600),
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: Alignment.topCenter,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 90),
      child: ConstrainedBox(
        constraints: constraints,
        child: child,
      ),
    );
  }
}

/// Commonly used structure for desktop dialogs.
///
/// Keep in mind that this dialog has fixed size of 900x600 and
/// is always adding close button in top right corner.
class VoicesDesktopPanelsDialog extends StatelessWidget {
  final Widget left;
  final Widget right;

  const VoicesDesktopPanelsDialog({
    super.key,
    required this.left,
    required this.right,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return VoicesDesktopDialog(
      constraints: const BoxConstraints.tightFor(width: 900, height: 600),
      child: Stack(
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
          const _DialogCloseButton(),
        ],
      ),
    );
  }
}

class _DialogCloseButton extends StatelessWidget {
  const _DialogCloseButton();

  @override
  Widget build(BuildContext context) {
    const buttonStyle = ButtonStyle(
      fixedSize: WidgetStatePropertyAll(Size.square(48)),
    );

    return Align(
      alignment: Alignment.topRight,
      child: IconButtonTheme(
        data: const IconButtonThemeData(style: buttonStyle),
        child: XButton(
          onTap: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }
}
