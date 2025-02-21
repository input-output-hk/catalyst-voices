import 'package:catalyst_voices/widgets/modals/voices_share_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group(VoicesShareDialog, () {
    late Widget testWidget;

    setUp(() {
      testWidget = const Scaffold(
        body: SizedBox(
          width: 1600,
          height: 1600,
          child: VoicesShareDialog(
            shareItemType: 'proposal',
            shareUrl: 'test-url.com',
            shareMessage: 'Test share message',
          ),
        ),
      );
    });

    testWidgets('renders all share options', (tester) async {
      await tester.pumpApp(
        testWidget,
      );
      await tester.pumpAndSettle();
      for (final shareType in ShareType.values) {
        expect(find.byKey(Key(shareType.name)), findsOneWidget);
      }
    });

    testWidgets('displays correct header title', (tester) async {
      await tester.pumpApp(testWidget);
      await tester.pumpAndSettle();

      expect(find.textContaining('Share proposal'), findsOneWidget);
    });
  });

  group(ShareType, () {
    test('generates correct share URLs', () {
      const testUrl = 'https://example.com';
      const testMessage = 'Test message';

      expect(
        ShareType.xTwitter.shareUrl(testMessage, testUrl),
        contains('twitter.com/intent/tweet'),
      );

      expect(
        ShareType.linkedin.shareUrl(testMessage, testUrl),
        contains('linkedin.com/sharing/share-offsite'),
      );

      expect(
        ShareType.facebook.shareUrl(testMessage, testUrl),
        contains('facebook.com/sharer.php'),
      );

      expect(
        ShareType.reddit.shareUrl(testMessage, testUrl),
        contains('reddit.com/submit'),
      );
    });
  });
}
