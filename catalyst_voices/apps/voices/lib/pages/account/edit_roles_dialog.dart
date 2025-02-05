import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class EditRolesDialog extends StatelessWidget {
  const EditRolesDialog._();

  static Future<bool> show(BuildContext context) async {
    final result = await VoicesDialog.show<bool>(
      context: context,
      builder: (context) => const EditRolesDialog._(),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return VoicesDesktopInfoDialog(
      icon: VoicesAssets.icons.userGroup.buildIcon(),
      title: Text(context.l10n.editRolesDialogTitle),
      message: Text(context.l10n.editRolesDialogMessage),
      action: VoicesFilledButton(
        onTap: () => Navigator.of(context).pop(true),
        child: Text(context.l10n.continueText),
      ),
    );
  }
}
