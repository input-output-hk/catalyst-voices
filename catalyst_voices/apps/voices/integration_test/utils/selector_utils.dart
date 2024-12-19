import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

class SelectorUtils {
  static void isDisabled(PatrolTester $, PatrolFinder widget,
      {bool? reverse = false,}) {
    final widgetProps = $.tester.widget(widget).toString().split('(').last;
    var expectedState = reverse! ? 'enabled' : 'disabled';
    expect(
      widgetProps.contains('disabled'),
      !reverse,
      reason: 'Expected $expectedState (${widget.description})',
    );
  }

  static void isEnabled(PatrolTester $, PatrolFinder widget) {
    isDisabled($, widget, reverse: true);
  }
}
