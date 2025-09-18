import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_icon_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_outlined_button.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

/// A [VoicesFilledButton] that switches to [VoicesIconButton.filled] on small screens.
class VoicesResponsiveFilledButton extends StatelessWidget {
  final ButtonStyle? style;
  final VoidCallback? onTap;
  final Widget icon;
  final Widget child;

  const VoicesResponsiveFilledButton({
    super.key,
    this.style,
    this.onTap,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveChildBuilder(
      xs: (context) => VoicesIconButton.filled(
        style: style,
        onTap: onTap,
        child: icon,
      ),
      sm: (context) => VoicesFilledButton(
        style: style,
        onTap: onTap,
        leading: icon,
        child: child,
      ),
    );
  }
}

/// A [VoicesResponsiveOutlinedButton] that switches to [VoicesIconButton.outlined] on small screens.
class VoicesResponsiveOutlinedButton extends StatelessWidget {
  final ButtonStyle? style;
  final VoidCallback? onTap;
  final Widget icon;
  final Widget child;

  const VoicesResponsiveOutlinedButton({
    super.key,
    this.style,
    this.onTap,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveChildBuilder(
      xs: (context) => VoicesIconButton.outlined(
        style: style,
        onTap: onTap,
        child: icon,
      ),
      sm: (context) => VoicesOutlinedButton(
        style: style,
        onTap: onTap,
        leading: icon,
        child: child,
      ),
    );
  }
}
