import 'dart:async';

import 'package:catalyst_voices/notification/catalyst_notification.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

const _showOnRoutes = [DiscoveryRoute.name, WorkspaceRoute.name];

final class AccountNeedsVerificationBanner extends BannerNotification {
  final bool _isProposer;

  AccountNeedsVerificationBanner({
    required Account account,
  }) : _isProposer = account.hasRole(AccountRole.proposer),
       super(
         id: account.catalystId.toString(),
         routerPredicate: (state) => _showOnRoutes.contains(state.name),
       );

  @override
  BannerNotificationMessage message(BuildContext context) {
    if (_isProposer) {
      return BannerNotificationMessage(
        text: context.l10n.emailNotVerifiedBannerProposerMessage,
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

    return BannerNotificationMessage(
      text: context.l10n.emailNotVerifiedBannerContributorMessage,
    );
  }

  @override
  String title(BuildContext context) {
    return context.l10n.emailNotVerifiedBannerTitle;
  }
}
