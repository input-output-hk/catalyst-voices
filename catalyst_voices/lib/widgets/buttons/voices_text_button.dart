import 'package:catalyst_voices/widgets/buttons/voices_button_affix_decoration.dart';
import 'package:flutter/material.dart';

enum _Type { primary, neutral, secondary }

/// A button that combines a `TextButton` with optional leading and trailing
/// elements.
///
/// This widget provides a convenient way to add icons or other widgets before
/// or after the button's child.
class VoicesTextButton extends StatelessWidget {
  /// The callback function invoked when the button is pressed.
  final VoidCallback? onTap;

  /// The widget to be displayed before the button's main content.
  final Widget? leading;

  /// The widget to be displayed after the button's main content.
  final Widget? trailing;

  /// The main content of the button.
  final Widget child;

  const VoicesTextButton({
    super.key,
    this.onTap,
    this.leading,
    this.trailing,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: VoicesButtonAffixDecoration(
        leading: leading,
        trailing: trailing,
        child: child,
      ),
    );
  }
}
