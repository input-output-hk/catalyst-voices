import 'package:catalyst_voices/common/ext/ext.dart';
import 'package:catalyst_voices/widgets/modals/details/voices_align_title_header.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar.dart';
import 'package:catalyst_voices/widgets/snackbar/voices_snackbar_type.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ShareType {
  clipboard('Clipboard'),
  xTwitter('X / Twitter'),
  linkedin('LinkedIn'),
  facebook('Facebook'),
  reddit('Reddit');

  final String name;

  const ShareType(this.name);

  SvgGenImage get icon => switch (this) {
        ShareType.clipboard => VoicesAssets.icons.duplicate,
        ShareType.xTwitter => VoicesAssets.icons.xTwitter,
        ShareType.linkedin => VoicesAssets.icons.linkedin,
        ShareType.facebook => VoicesAssets.icons.facebook,
        ShareType.reddit => VoicesAssets.icons.reddit,
      };

  String description(VoicesLocalizations l10n, String itemType) =>
      switch (this) {
        ShareType.clipboard => l10n.shareDirectLinkToItem(itemType),
        ShareType.xTwitter => l10n.shareLinkOnSocialMedia(itemType, name),
        ShareType.linkedin => l10n.shareLinkOnSocialMedia(itemType, name),
        ShareType.facebook => l10n.shareLinkOnSocialMedia(itemType, name),
        ShareType.reddit => l10n.shareLinkOnSocialMedia(itemType, name),
      };

  String shareMessage(VoicesLocalizations l10n) => switch (this) {
        ShareType.clipboard => l10n.copyLink,
        _ => l10n.shareOnSocialMedia(name),
      };

  String shareUrl(String shareMessage, String url) => switch (this) {
        ShareType.xTwitter => _twitterShareUrl(url, shareMessage).toString(),
        ShareType.linkedin => _linkedinShareUrl(url).toString(),
        ShareType.facebook => _facebookShareUrl(url).toString(),
        ShareType.reddit => _redditShareUrl(url, shareMessage).toString(),
        _ => '',
      };

  Uri _facebookShareUrl(String url) {
    return Uri.https(
      'facebook.com',
      'sharer.php',
      {
        'u': url,
      },
    );
  }

  Uri _linkedinShareUrl(String url) {
    return Uri.https(
      'linkedin.com',
      'sharing/share-offsite',
      {
        'url': url,
      },
    );
  }

  Uri _redditShareUrl(String url, String shareMessage) {
    return Uri.https(
      'reddit.com',
      'submit',
      {
        'url': url,
        'shareMessage': shareMessage,
      },
    );
  }

  Uri _twitterShareUrl(String url, String shareMessage) {
    return Uri.https(
      'twitter.com',
      'intent/tweet',
      {
        'url': url,
        'text': shareMessage,
      },
    );
  }
}

class VoicesShareDialog extends StatelessWidget {
  final EdgeInsets bodyPadding;

  /// Information what is being shared for example
  /// proposal, campaign
  /// Its used in header of the dialog
  final String shareItemType;
  final String shareUrl;
  final String shareMessage;

  const VoicesShareDialog({
    super.key,
    this.bodyPadding = const EdgeInsets.all(24),
    required this.shareItemType,
    required this.shareUrl,
    required this.shareMessage,
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
            children: [
              ...ShareType.values.map<Widget>(
                (e) => _ShareItem(
                  key: Key(e.name),
                  shareType: e,
                  itemType: context.l10n.proposal.toLowerCase(),
                  shareUrl: shareUrl,
                  shareMessage: shareMessage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShareItem extends StatelessWidget with LaunchUrlMixin {
  final ShareType shareType;
  final String itemType;
  final String shareUrl;
  final String shareMessage;

  const _ShareItem({
    super.key,
    required this.shareType,
    required this.itemType,
    required this.shareUrl,
    required this.shareMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: CatalystPlatform.isWeb
            ? () async => _webShareItem(context)
            : _shareItem,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: context.colors.outlineBorderVariant,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            spacing: 16,
            children: [
              VoicesAvatar(
                icon: shareType.icon.buildIcon(),
                backgroundColor:
                    context.colors.elevationsOnSurfaceNeutralLv1Grey,
                foregroundColor: context.colors.iconsForeground,
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shareType.shareMessage(context.l10n),
                    ),
                    Text(
                      shareType.description(context.l10n, itemType),
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

  void _shareItem() {
    throw UnimplementedError(
      'Share method for other platforms is not implemented yet',
    );
  }

  void _showSnackbar(BuildContext context) {
    VoicesSnackBar(
      type: VoicesSnackBarType.success,
      title: context.l10n.copied,
      message: context.l10n.linkCopiedToClipboard,
      duration: const Duration(seconds: 2),
    ).show(context);
  }

  Future<void> _webShareItem(BuildContext context) async {
    final url = '${Uri.base.host}:${Uri.base.port}$shareUrl';
    if (shareType == ShareType.clipboard) {
      _showSnackbar(context);
      return Clipboard.setData(ClipboardData(text: url));
    } else {
      await launchUri(shareType.shareUrl(shareMessage, url).getUri());
    }
  }
}
