import 'package:catalyst_voices_models/catalyst_voices_models.dart';

enum ShareChannel {
  clipboard('Clipboard'),
  xTwitter('X / Twitter'),
  linkedin('LinkedIn'),
  facebook('Facebook'),
  reddit('Reddit');

  final String name;

  const ShareChannel(this.name);

  Uri buildShareUri(ShareData data) => switch (this) {
        ShareChannel.clipboard => data.uri,
        ShareChannel.xTwitter => _adaptForTwitter(data),
        ShareChannel.linkedin => _adaptForLinkedin(data),
        ShareChannel.facebook => _adaptForFacebook(data),
        ShareChannel.reddit => _adaptForReddit(data),
      };

  Uri _adaptForFacebook(ShareData data) {
    return Uri.https(
      'facebook.com',
      'sharer.php',
      {
        'u': data.uri.toString(),
      },
    );
  }

  Uri _adaptForLinkedin(ShareData data) {
    return Uri.https(
      'linkedin.com',
      'sharing/share-offsite',
      {
        'url': data.uri.toString(),
      },
    );
  }

  Uri _adaptForReddit(ShareData data) {
    final additionalMessage = data.additionalMessage;

    return Uri.https(
      'reddit.com',
      'submit',
      {
        'url': data.uri.toString(),
        if (additionalMessage != null) 'shareMessage': additionalMessage,
      },
    );
  }

  Uri _adaptForTwitter(ShareData data) {
    final additionalMessage = data.additionalMessage;

    return Uri.https(
      'twitter.com',
      'intent/tweet',
      {
        'url': data.uri.toString(),
        if (additionalMessage != null) 'text': additionalMessage,
      },
    );
  }
}
