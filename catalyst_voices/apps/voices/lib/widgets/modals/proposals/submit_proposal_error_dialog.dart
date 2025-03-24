import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/modals/voices_alert_dialog.dart';
import 'package:catalyst_voices/widgets/modals/voices_dialog.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

/// Error dialog when submitting proposal for review fails..
class SubmitProposalErrorDialog {
  static Future<void> show({
    required BuildContext context,
    required ProposalBuilderSubmitException exception,
  }) {
    return VoicesDialog.show(
      context: context,
      routeSettings: const RouteSettings(
        name: '/proposal-builder/submit-error',
      ),
      builder: (context) {
        return VoicesAlertDialog(
          icon: VoicesAssets.icons.exclamation.buildIcon(
            size: 48,
            color: Theme.of(context).colors.iconsWarning,
          ),
          subtitle: Text(exception.title(context)),
          content: Text(exception.message(context)),
          buttons: [
            VoicesFilledButton(
              onTap: () => Navigator.of(context).pop(),
              child: Text(context.l10n.okay),
            ),
          ],
        );
      },
    );
  }
}
