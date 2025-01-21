import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class SeedPhraseActions extends StatelessWidget {
  final VoidCallback? onImportKeyTap;
  final VoidCallback? onResetTap;

  const SeedPhraseActions({
    super.key,
    this.onImportKeyTap,
    this.onResetTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        VoicesTextButton(
          key: const Key('UploadKeyButton'),
          onTap: onImportKeyTap,
          child: Text(context.l10n.uploadCatalystKey),
        ),
        const Spacer(),
        if (onResetTap != null)
          VoicesTextButton(
            key: const Key('ResetButton'),
            onTap: onResetTap,
            child: Text(context.l10n.reset),
          ),
      ],
    );
  }
}
