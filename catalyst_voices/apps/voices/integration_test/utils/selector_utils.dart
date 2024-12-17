import 'package:flutter_test/flutter_test.dart';
import 'package:patrol_finders/patrol_finders.dart';

class SelectorUtils {
  static void isDisabled(PatrolTester $, PatrolFinder widget) {
    final widgetProps = $.tester.widget(widget).toString().split('(').last;
    expect(
      widgetProps.contains('disabled'),
      true,
      reason: 'Expected disabled (${widget.description})',
    );
  }
}
