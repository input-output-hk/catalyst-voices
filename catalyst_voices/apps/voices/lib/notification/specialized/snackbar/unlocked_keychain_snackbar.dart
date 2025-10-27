import 'package:catalyst_voices/notification/catalyst_notification.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:uuid_plus/uuid_plus.dart';

final _id = const Uuid().v4();

/// A specialized snackbar notification shown when the keychain is unlocked.
final class UnlockedKeychainSnackbar extends SnackbarNotification {
  UnlockedKeychainSnackbar()
      : super(
          id: _id,
          type: CatalystNotificationType.success,
        );

  @override
  String title(BuildContext context) {
    return context.l10n.unlockSnackbarTitle;
  }

  @override
  String message(BuildContext context) {
    return context.l10n.unlockSnackbarMessage;
  }

  @override
  Widget? icon(BuildContext context) {
    return VoicesAssets.icons.lockOpen.buildIcon();
  }
}
