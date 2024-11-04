import 'package:catalyst_voices/widgets/common/navigation_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group(NavigationLocation, () {
    testWidgets(
      'renders correctly',
      (tester) async {
        // Given
        const navigationLocation = NavigationLocation(
          parts: ['Home', 'Products', 'Cart'],
        );

        // When
        await tester.pumpApp(navigationLocation);
        await tester.pumpAndSettle();

        // Then
        expect(
          find.byWidgetPredicate(
            (widget) =>
                widget is RichText &&
                widget.text.toPlainText() == 'Home / Products / Cart',
            description: 'Finds RichText widget with matching text',
          ),
          findsOne,
        );
      },
    );

    testWidgets(
      'handles empty parts list',
      (tester) async {
        // Given
        const navigationLocation = NavigationLocation(parts: []);

        // When
        await tester.pumpApp(navigationLocation);
        await tester.pumpAndSettle();

        // Then
        expect(
          find.byWidgetPredicate(
            (widget) => widget is RichText && widget.text.toPlainText() == '',
            description: 'Finds empty RichText',
          ),
          findsOne,
        );
      },
    );
  });
}
