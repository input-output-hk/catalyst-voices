import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

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
}
