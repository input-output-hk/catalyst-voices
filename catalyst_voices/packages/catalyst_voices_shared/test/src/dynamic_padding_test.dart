import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  Widget buildApp(Size size) => MediaQuery(
    data: MediaQueryData(size: size), 
    child: MaterialApp(
      home: Scaffold(
        body: DynamicPadding(
          xs: const EdgeInsets.all(2),
          sm: const EdgeInsets.symmetric(vertical: 4),
          md: const EdgeInsets.symmetric(horizontal: 8),
          lg: const EdgeInsets.only(top: 16),
          child: const Text('Test data!'),
        ),
      ),
    ),
  );
  group('Test screen sizes', () {

    final sizesToTest = {
      280.0: const EdgeInsets.all(2),
      620.0: const EdgeInsets.symmetric(vertical: 4),
      1280.0: const EdgeInsets.symmetric(horizontal: 8),
      1600.0: const EdgeInsets.only(top: 16),
    };

    for (final entry in sizesToTest.entries) {
      testWidgets(
        'DynamicPadding adapts to screen of width $entry.key',
        (tester) async {
          await tester.pumpWidget(
            buildApp(Size.fromWidth(entry.key)),
          );

          final testedElement = find.byType(Text);
          // Verify the Widget renders properly
          expect(testedElement, findsOneWidget);
          final paddingWidget = tester.widget<Padding>(
            find.ancestor(
              of: testedElement,
              matching: find.byType(Padding),
            ),
          );
          // Check that the padding corresponds
          expect(paddingWidget.padding, entry.value);
        }
      );
    }
   
  });
}
