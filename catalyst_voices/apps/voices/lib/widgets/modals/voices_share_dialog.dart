import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/share/share_manager.dart';
import 'package:catalyst_voices/widgets/modals/details/voices_align_title_header.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class VoicesShareDialog extends StatelessWidget {
  final EdgeInsets bodyPadding;

  /// Information what is being shared for example
  /// proposal, campaign
  /// Its used in header of the dialog
  final String shareItemType;
  final ShareData data;

  const VoicesShareDialog({
    super.key,
    this.bodyPadding = const EdgeInsets.all(24),
    required this.shareItemType,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesDetailsDialog(
      constraints: const BoxConstraints(
        maxWidth: 524,
        maxHeight: 549,
      ),
      header: VoicesAlignTitleHeader(
        title: context.l10n.shareType(shareItemType),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      ),
      body: Padding(
        padding: bodyPadding,
        child: SingleChildScrollView(
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: ShareChannel.values.map((channel) {
              return _ShareItemTile(
                key: ValueKey(channel),
                icon: channel.icon,
                title: channel.title(context),
                desc: channel.description(context, itemType: shareItemType.toLowerCase()),
                onTap: () => unawaited(_shareViaChannel(context, channel)),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Future<void> _shareViaChannel(BuildContext context, ShareChannel channel) async {
    await ShareManager.of(context).share(data, channel: channel);

    if (context.mounted && channel == ShareChannel.clipboard) {
      _showCopied(context);
    }
  }

  void _showCopied(BuildContext context) {
    VoicesSnackBar(
      type: VoicesSnackBarType.success,
      behavior: SnackBarBehavior.floating,
      title: context.l10n.copied,
      message: context.l10n.linkCopiedToClipboard,
      duration: const Duration(seconds: 2),
    ).show(context);
  }
}

class _ShareItemTile extends StatelessWidget with LaunchUrlMixin {
  final SvgGenImage icon;
  final String title;
  final String desc;
  final VoidCallback onTap;

  const _ShareItemTile({
    super.key,
    required this.icon,
    required this.title,
    required this.desc,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: context.colors.outlineBorderVariant),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            key: const Key('ShareItem'),
            spacing: 16,
            children: [
              VoicesAvatar(
                key: const Key('ItemIcon'),
                icon: icon.buildIcon(),
                backgroundColor: context.colors.elevationsOnSurfaceNeutralLv1Grey,
                foregroundColor: context.colors.iconsForeground,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      key: const Key('ItemTitle'),
                      title,
                    ),
                    Text(
                      key: const Key('ItemDescription'),
                      desc,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
