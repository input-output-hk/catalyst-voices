import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

extension ShareChannelExt on ShareChannel {
  SvgGenImage get icon => switch (this) {
        ShareChannel.clipboard => VoicesAssets.icons.duplicate,
        ShareChannel.xTwitter => VoicesAssets.icons.xTwitter,
        ShareChannel.linkedin => VoicesAssets.icons.linkedin,
        ShareChannel.facebook => VoicesAssets.icons.facebook,
        ShareChannel.reddit => VoicesAssets.icons.reddit,
      };

  String description(
    BuildContext context, {
    required String itemType,
  }) =>
      switch (this) {
        ShareChannel.clipboard => context.l10n.shareDirectLinkToItem(itemType),
        ShareChannel.xTwitter => context.l10n.shareLinkOnSocialMedia(itemType, name),
        ShareChannel.linkedin => context.l10n.shareLinkOnSocialMedia(itemType, name),
        ShareChannel.facebook => context.l10n.shareLinkOnSocialMedia(itemType, name),
        ShareChannel.reddit => context.l10n.shareLinkOnSocialMedia(itemType, name),
      };

  String title(BuildContext context) => switch (this) {
        ShareChannel.clipboard => context.l10n.copyLink,
        _ => context.l10n.shareOnSocialMedia(name),
      };
}
