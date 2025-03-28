import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

import 'mock_url_launcher_platform.dart';

class SelectorUtils {
  static void isDisabled(
    PatrolTester $,
    PatrolFinder widget, {
    bool? reverse = false,
  }) {
    final dynamic widgetProps = $.tester.widget(widget);
    final expectedState = reverse! ? 'enabled' : 'disabled';
    expect(
      widgetProps.enabled, // ignore: avoid_dynamic_calls
      reverse,
      reason: 'Expected $expectedState (${widget.description})',
    );
  }

  static void isEnabled(PatrolTester $, PatrolFinder widget) {
    isDisabled($, widget, reverse: true);
  }

  static Future<void> checkOpeningLinkByMocking(
    PatrolTester $,
    String elementText,
    String urlPart,
  ) async {
    final mockUrlLauncherPlatform = MockUrlLauncherPlatform();
    await $.tester.tapOnText(find.textRange.ofSubstring(elementText));
    expect(
      mockUrlLauncherPlatform.capturedUrl.contains(urlPart),
      true,
      reason: 'Link URL does not match: \nexpected $urlPart'
          '\ngot ${mockUrlLauncherPlatform.capturedUrl}',
    );
    mockUrlLauncherPlatform.tearDownMock();
  }
}
