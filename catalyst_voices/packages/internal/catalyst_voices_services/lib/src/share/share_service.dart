import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/src/share/share_app_resource_url_resolver.dart';
import 'package:catalyst_voices_services/src/share/share_reviews_resource_url_resolver.dart';
import 'package:catalyst_voices_services/src/share/strategy/clipboard_share_strategy.dart';
import 'package:catalyst_voices_services/src/share/strategy/launch_share_strategy.dart';
import 'package:catalyst_voices_services/src/share/strategy/share_strategy.dart';
import 'package:flutter/foundation.dart';

abstract interface class ShareService {
  const factory ShareService(
    ShareAppResourceUrlResolver appResourceResolver,
    ShareReviewsResourceUrlResolver reviewsResourceResolver,
  ) = ShareServiceImpl;

  Uri becomeReviewer();

  Uri resolveProposalUrl({required DocumentRef ref});

  Future<void> share(ShareData data, {required ShareChannel channel});
}

final class ShareServiceImpl implements ShareService {
  final ShareAppResourceUrlResolver appResourceResolver;
  final ShareReviewsResourceUrlResolver reviewsResourceResolver;

  const ShareServiceImpl(
    this.appResourceResolver,
    this.reviewsResourceResolver,
  );

  @override
  Uri becomeReviewer() => reviewsResourceResolver.becomeReviewer();

  @override
  Uri resolveProposalUrl({required DocumentRef ref}) => appResourceResolver.proposal(ref: ref);

  @override
  Future<void> share(ShareData data, {required ShareChannel channel}) async {
    final strategy = _pickShareStrategy(channel);

    final uri = channel.buildShareUri(data);

    await strategy.share(uri);
  }

  ShareStrategy _pickShareStrategy(ShareChannel channel) {
    return switch (channel) {
      ShareChannel.clipboard => const ClipboardShareStrategy(),
      ShareChannel.xTwitter ||
      ShareChannel.linkedin ||
      ShareChannel.facebook ||
      ShareChannel.reddit when kIsWeb =>
        const LaunchShareStrategy(),
      _ => throw UnimplementedError('Platform share is not implemented'),
    };
  }
}
