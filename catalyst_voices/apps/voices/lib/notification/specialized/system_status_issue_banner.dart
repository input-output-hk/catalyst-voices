import 'package:catalyst_voices/common/constants/constants.dart';
import 'package:catalyst_voices/notification/catalyst_notification.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/widgets.dart';
import 'package:uuid_plus/uuid_plus.dart';

final _id = const Uuid().v4();

final class SystemStatusIssueBanner extends BannerNotification with LaunchUrlMixin {
  SystemStatusIssueBanner()
    : super(
        id: _id,
        priority: 1,
      );

  @override
  String title(BuildContext context) {
    return context.l10n.systemStatusIssueBannerTitle;
  }

  @override
  BannerNotificationMessage message(BuildContext context) {
    return BannerNotificationMessage(
      text: context.l10n.systemStatusIssueBannerMessage,
      placeholders: {
        'readMoreLink': CatalystNotificationTextPart(
          text: context.l10n.readMore,
          onTap: (context) async {
            await launchUri(VoicesConstants.systemStatusUrl.getUri());
          },
        ),
      },
    );
  }
}
