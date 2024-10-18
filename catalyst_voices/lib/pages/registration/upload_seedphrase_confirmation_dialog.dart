import 'package:catalyst_voices/widgets/avatars/voices_avatar.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices/widgets/modals/voices_alert_dialog.dart';
import 'package:catalyst_voices/widgets/modals/voices_dialog.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class UploadSeedphraseConfirmationDialog extends StatelessWidget {
  const UploadSeedphraseConfirmationDialog({
    super.key,
  });

  static Future<bool> show(BuildContext context) async {
    final result = await VoicesDialog.show<bool>(
      context: context,
      builder: (context) => const UploadSeedphraseConfirmationDialog(),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return VoicesAlertDialog(
      title: Text(context.l10n.alert.toUpperCase()),
      icon: VoicesAvatar(
        radius: 40,
        backgroundColor: Colors.transparent,
        icon: VoicesAssets.icons.exclamation.buildIcon(
          size: 36,
          color: Theme.of(context).colors.iconsError,
        ),
        border: Border.all(
          color: Theme.of(context).colors.iconsError!,
          width: 3,
        ),
      ),
      subtitle: Text(context.l10n.uploadConfirmDialogSubtitle),
      content: Text(context.l10n.uploadConfirmDialogContent),
      buttons: [
        VoicesFilledButton(
          child: Text(context.l10n.uploadConfirmDialogYesButton),
          onTap: () => Navigator.of(context).pop(true),
        ),
        VoicesTextButton(
          child: Text(context.l10n.uploadConfirmDialogResumeButton),
          onTap: () => Navigator.of(context).pop(false),
        ),
      ],
    );
  }
}
