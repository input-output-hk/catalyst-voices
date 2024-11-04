import 'package:catalyst_voices/widgets/common/link_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group(LinkText, () {
    testWidgets('renders correctly and triggers onTap', (tester) async {
      // Given
      final tapNotifier = ValueNotifier(false);
      final widget = Scaffold(
        body: LinkText(
          'This is a link',
          onTap: () {
            tapNotifier.value = true;
          },
        ),
      );

      // When
      await tester.pumpApp(widget);
      await tester.pumpAndSettle();

      // Then
      // Verify that the text and underline are rendered correctly
      expect(find.text('This is a link'), findsOne);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Text &&
              widget.data == 'This is a link' &&
              widget.style?.decoration == TextDecoration.underline,
        ),
        findsOne,
      );

      // Simulate a tap and verify that the onTap callback is called
      await tester.tap(find.text('This is a link'));
      await tester.pump();
      expect(tapNotifier.value, true);
    });
  });
}
