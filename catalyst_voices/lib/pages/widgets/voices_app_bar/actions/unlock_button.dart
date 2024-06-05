import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

/// An [UnlockButton] widget that is used to display a call to action to
/// unlock an account currently locked in the app.
class UnlockButton extends StatelessWidget {
  final void Function()? onPressed;

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
        icon: const Icon(CatalystVoicesIcons.lock_open),
      ),
      other: (context) => FilledButton.icon(
        onPressed: onPressed,
        icon: const Icon(
          Icons.lock_open,
          size: 18,
        ),
        label: Text(context.l10n.unlockButtonLabelText),
        // TODO(coire1): flutter upgrade iconAlignment: IconAlignment.start,
      ),
    );
  }
}
