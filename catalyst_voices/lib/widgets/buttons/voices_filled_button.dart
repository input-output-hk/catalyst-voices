import 'package:catalyst_voices/widgets/buttons/voices_button_affix_decoration.dart';
import 'package:flutter/material.dart';

/// A button that combines a `FilledButton` with optional leading and trailing
/// elements.
///
/// This widget provides a convenient way to add icons or other widgets before
/// or after the button's child.
class VoicesFilledButton extends StatelessWidget {
  /// The callback function invoked when the button is pressed.
  final VoidCallback? onTap;

  /// The widget to be displayed before the button's main content.
  final Widget? leading;

  /// The widget to be displayed after the button's main content.
  final Widget? trailing;

  /// The optional button's background color.
  final Color? backgroundColor;

  /// The main content of the button.
  final Widget child;

  const VoicesFilledButton({
    super.key,
    this.onTap,
    this.leading,
    this.trailing,
    this.backgroundColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor,
      ),
      onPressed: onTap,
      child: VoicesButtonAffixDecoration(
        leading: leading,
        trailing: trailing,
        child: child,
      ),
    );
  }
}
