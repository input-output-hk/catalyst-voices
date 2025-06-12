import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:test/test.dart';

void main() {
  group(ShareChannel, () {
    test('generates correct share URLs', () {
      final testData = ShareData(
        uri: Uri.parse('https://example.com'),
        additionalMessage: 'Test message',
      );

      expect(
        ShareChannel.xTwitter.buildShareUri(testData).toString(),
        contains('twitter.com/intent/tweet'),
      );

      expect(
        ShareChannel.linkedin.buildShareUri(testData).toString(),
        contains('linkedin.com/sharing/share-offsite'),
      );

      expect(
        ShareChannel.facebook.buildShareUri(testData).toString(),
        contains('facebook.com/sharer.php'),
      );

      expect(
        ShareChannel.reddit.buildShareUri(testData).toString(),
        contains('reddit.com/submit'),
      );
    });
  });
}
