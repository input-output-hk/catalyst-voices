import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class SeedPhraseActions extends StatelessWidget {
  final VoidCallback? onUploadKeyTap;
  final VoidCallback? onResetTap;

  const SeedPhraseActions({
    super.key,
    this.onUploadKeyTap,
    this.onResetTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        VoicesTextButton(
          onTap: onUploadKeyTap,
          child: Text(context.l10n.uploadCatalystKey),
        ),
        const Spacer(),
        if (onResetTap != null)
          VoicesTextButton(
            onTap: onResetTap,
            child: Text(context.l10n.reset),
          ),
      ],
    );
  }
}
