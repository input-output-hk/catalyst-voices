import 'dart:async';

import 'package:catalyst_voices/notification/catalyst_notification.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:uuid_plus/uuid_plus.dart';

const _showOnRoutes = [DiscoveryRoute.name, WorkspaceRoute.name];
final _id = const Uuid().v4();

final class AccountContributorNeedsVerificationBanner extends AccountNeedsVerificationBanner {
  AccountContributorNeedsVerificationBanner();

  @override
  BannerNotificationMessage message(BuildContext context) {
    return BannerNotificationMessage(
      text: context.l10n.emailNotVerifiedBannerContributorMessage,
    );
  }
}

abstract base class AccountNeedsVerificationBanner extends BannerNotification {
  AccountNeedsVerificationBanner()
    : super(
        id: _id,
        routerPredicate: (state) => _showOnRoutes.contains(state.name),
      );

  @override
  String title(BuildContext context) {
    return context.l10n.emailNotVerifiedBannerTitle;
  }
}

final class AccountProposerNeedsVerificationBanner extends AccountNeedsVerificationBanner {
  AccountProposerNeedsVerificationBanner();

  @override
  BannerNotificationMessage message(BuildContext context) {
    return BannerNotificationMessage(
      text: context.l10n.emailNotVerifiedBannerProposerMessage('{destination}'),
      placeholders: {
        'destination': CatalystNotificationTextPart(
          text: context.l10n.myAccount,
          onTap: (context) {
            unawaited(const AccountRoute().push(context));
          },
        ),
      },
    );
  }
}
