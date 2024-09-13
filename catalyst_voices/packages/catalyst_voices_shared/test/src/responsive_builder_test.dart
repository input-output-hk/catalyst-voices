import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildApp(
    Size size,
    Widget child,
  ) =>
      MediaQuery(
        data: MediaQueryData(size: size),
        child: MaterialApp(
          home: Scaffold(
            body: child,
          ),
        ),
      );

  group('Test screen sizes with Text child', () {
    final sizesToTest = {
      280.0: 'Xs device',
      620.0: 'Small device',
      1280.0: 'Medium device',
      1600.0: 'Large device',
      3000.0: 'Other device',
    };

    for (final entry in sizesToTest.entries) {
      testWidgets('ResponsiveBuilder adapts to screen of width $entry.key',
          (tester) async {
        await tester.pumpWidget(
          buildApp(
            Size.fromWidth(entry.key),
            ResponsiveBuilder<String>(
              xs: 'Xs device',
              sm: 'Small device',
              md: 'Medium device',
              lg: 'Large device',
              other: 'Other device',
              builder: (context, data) => Text(data),
            ),
          ),
        );

        final testedElement = find.byType(Text);
        // Verify the Widget renders properly
        expect(testedElement, findsOneWidget);
        // Verify the proper text is rendered
        expect(find.text(entry.value), findsOneWidget);
      });
    }
  });

  group('Test screen sizes with specific Padding', () {
    final sizesToTest = {
      280.0: const EdgeInsets.all(2),
      620.0: const EdgeInsets.all(4),
      1280.0: const EdgeInsets.all(8),
      1600.0: const EdgeInsets.all(16),
      3000.0: const EdgeInsets.all(32),
    };

    for (final entry in sizesToTest.entries) {
      testWidgets('ResponsiveBuilder adapts to screen of width $entry.key',
          (tester) async {
        await tester.pumpWidget(
          buildApp(
            Size.fromWidth(entry.key),
            ResponsiveBuilder<EdgeInsets>(
              xs: const EdgeInsets.all(2),
              sm: const EdgeInsets.all(4),
              md: const EdgeInsets.all(8),
              lg: const EdgeInsets.all(16),
              other: const EdgeInsets.all(32),
              builder: (context, padding) => Padding(
                padding: padding,
                child: const Text('Test'),
              ),
            ),
          ),
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
      });
    }
  });
}
