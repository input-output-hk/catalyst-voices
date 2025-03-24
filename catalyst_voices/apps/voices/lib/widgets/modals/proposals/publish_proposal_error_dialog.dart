import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/modals/voices_dialog.dart';
import 'package:catalyst_voices/widgets/modals/voices_info_dialog.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

/// Error dialog when publishing proposal to server fails.
class PublishProposalErrorDialog {
  static Future<void> show({
    required BuildContext context,
    required ProposalBuilderPublishException exception,
  }) {
    return VoicesDialog.show(
      context: context,
      routeSettings: const RouteSettings(
        name: '/proposal-builder/publish-error',
      ),
      builder: (context) {
        return VoicesDesktopInfoDialog(
          icon: VoicesAssets.icons.exclamation.buildIcon(
            color: Theme.of(context).colors.iconsWarning,
          ),
          title: Text(exception.title(context)),
          message: Text(exception.message(context)),
          action: VoicesFilledButton(
            onTap: () => Navigator.of(context).pop(),
            child: Text(context.l10n.okay),
          ),
        );
      },
    );
  }
}
