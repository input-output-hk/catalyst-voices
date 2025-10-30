import 'package:catalyst_voices/notification/catalyst_notification.dart';
import 'package:catalyst_voices/routes/routing/root_route.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/modals/voices_info_dialog.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

final class KeychainDeletedDialogNotification extends DialogNotification {
  KeychainDeletedDialogNotification()
    : super(
        id: 'keychainDeleteDialog',
        routerPredicate: (state) => RootRoute.rootRouteNameOptions.contains(state.name),
      );

  @override
  Widget buildDialog(BuildContext context) {
    return const _KeychainDeletedDialog();
  }
}

class _KeychainDeletedDialog extends StatelessWidget {
  const _KeychainDeletedDialog();

  @override
  Widget build(BuildContext context) {
    return VoicesInfoDialog(
      icon: VoicesAssets.icons.checkCircle.buildIcon(),
      title: Text(context.l10n.keychainDeletedDialogTitle),
      message: Text(context.l10n.keychainDeletedDialogSubtitle),
      action: VoicesFilledButton(
        key: const Key('KeychainDeletedDialogCloseButton'),
        onTap: () => Navigator.of(context).pop(),
        child: Text(context.l10n.close),
      ),
    );
  }
}
