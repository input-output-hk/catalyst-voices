import 'package:catalyst_voices/notification/catalyst_notification.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

final class NewVersionAvailableBanner extends BannerNotification {
  const NewVersionAvailableBanner()
    : super(
        id: 'newVersionAvailableBannerId',
        priority: 1,
      );

  @override
  BannerNotificationMessage message(BuildContext context) {
    if (CatalystPlatform.isWeb) {
      return BannerNotificationMessage(
        text: context.l10n.newAppVersionAvailableDescriptionWeb,
      );
    } else {
      return BannerNotificationMessage(
        text: '{placeholder}',
        placeholders: {
          'placeholder': CatalystNotificationTextPart(
            text: context.l10n.newAppVersionAvailableDescriptionWeb,
            onTap: (context) {
              // TODO(LynxLynxx): Implement this method for mobile
            },
          ),
        },
      );
    }
  }

  @override
  String title(BuildContext context) {
    return context.l10n.newAppVersionAvailableTitle;
  }
}
