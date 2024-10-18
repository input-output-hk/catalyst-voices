import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices/widgets/modals/voices_alert_dialog.dart';
import 'package:catalyst_voices/widgets/modals/voices_dialog.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class IncorrectSeedPhraseDialog extends StatelessWidget {
  const IncorrectSeedPhraseDialog({
    super.key,
  });

  static Future<bool> show(BuildContext context) async {
    final result = await VoicesDialog.show<bool>(
      context: context,
      builder: (context) => const IncorrectSeedPhraseDialog(),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return VoicesAlertDialog(
      title: Text(context.l10n.warning.toUpperCase()),
      icon: CatalystImage.asset(
        VoicesAssets.images.keyIncorrect.path,
        width: 80,
        height: 80,
      ),
      subtitle: Text(context.l10n.incorrectUploadDialogSubtitle),
      content: Text(
        context.l10n.incorrectUploadDialogContent,
      ),
      buttons: [
        VoicesFilledButton(
          child: Text(context.l10n.incorrectUploadDialogTryAgainButton),
          onTap: () => Navigator.of(context).pop(true),
        ),
        VoicesTextButton(
          child: Text(context.l10n.cancelButtonText),
          onTap: () => Navigator.of(context).pop(false),
        ),
      ],
    );
  }
}
