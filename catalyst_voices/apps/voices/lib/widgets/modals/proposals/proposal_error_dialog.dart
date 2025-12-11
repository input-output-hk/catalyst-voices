import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/modals/voices_dialog.dart';
import 'package:catalyst_voices/widgets/modals/voices_info_dialog.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

/// Generic error dialog related to proposal errors.
class ProposalErrorDialog {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    return VoicesDialog.show(
      context: context,
      routeSettings: const RouteSettings(
        name: '/proposal-builder/error',
      ),
      builder: (context) {
        return VoicesInfoDialog(
          icon: VoicesAssets.icons.exclamation.buildIcon(
            color: Theme.of(context).colors.iconsWarning,
          ),
          title: Text(title),
          message: Text(message),
          action: VoicesFilledButton(
            onTap: () => Navigator.of(context).pop(),
            child: Text(context.l10n.okay),
          ),
        );
      },
    );
  }
}
