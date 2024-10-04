import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

/// An [UnlockButton] widget that is used to display a call to action to
/// unlock an account currently locked in the app.
class UnlockButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const UnlockButton({
    super.key,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveChild(
      xs: (context) => IconButton.filled(
        onPressed: onPressed,
        color: Theme.of(context).colors.iconsBackground,
        icon: VoicesAssets.icons.lockOpen.buildIcon(),
      ),
      other: (context) => FilledButton.icon(
        onPressed: onPressed,
        icon: VoicesAssets.icons.lockOpen.buildIcon(size: 18),
        label: Text(context.l10n.unlockButtonLabelText),
        iconAlignment: IconAlignment.end,
        style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsets>(
            const EdgeInsets.only(left: 24, right: 16),
          ),
        ),
      ),
    );
  }
}
