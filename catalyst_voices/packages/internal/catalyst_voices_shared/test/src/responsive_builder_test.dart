import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(ResponsiveBuilder, () {
    Widget buildApp(
      Size size,
      Widget child,
    ) => MediaQuery(
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
      };

      for (final entry in sizesToTest.entries) {
        testWidgets('adapts to screen of width ${entry.key}', (tester) async {
          await tester.pumpWidget(
            buildApp(
              Size.fromWidth(entry.key),
              ResponsiveBuilder<String>(
                xs: 'Xs device',
                sm: 'Small device',
                md: 'Medium device',
                lg: 'Large device',
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
      };

      for (final entry in sizesToTest.entries) {
        testWidgets('adapts to screen of width ${entry.key}', (tester) async {
          await tester.pumpWidget(
            buildApp(
              Size.fromWidth(entry.key),
              ResponsiveBuilder<EdgeInsets>(
                xs: const EdgeInsets.all(2),
                sm: const EdgeInsets.all(4),
                md: const EdgeInsets.all(8),
                lg: const EdgeInsets.all(16),
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

    group('Test screen sizes with fallbacks to smaller breakpoints', () {
      testWidgets('fallbacks to the only available "xs" breakpoint', (tester) async {
        await tester.pumpWidget(
          buildApp(
            const Size.fromWidth(3000),
            ResponsiveBuilder<String>(
              xs: 'xs',
              builder: (context, text) => Text(text),
            ),
          ),
        );

        expect(find.text('xs'), findsOneWidget);
      });

      testWidgets('fallbacks to the only available "sm" breakpoint', (tester) async {
        await tester.pumpWidget(
          buildApp(
            const Size.fromWidth(3000),
            ResponsiveBuilder<String>(
              sm: 'sm',
              builder: (context, text) => Text(text),
            ),
          ),
        );

        expect(find.text('sm'), findsOneWidget);
      });

      testWidgets('fallbacks to the only available "md" breakpoint', (tester) async {
        await tester.pumpWidget(
          buildApp(
            const Size.fromWidth(3000),
            ResponsiveBuilder<String>(
              md: 'md',
              builder: (context, text) => Text(text),
            ),
          ),
        );

        expect(find.text('md'), findsOneWidget);
      });

      testWidgets('fallbacks to the only available "lg" breakpoint', (tester) async {
        await tester.pumpWidget(
          buildApp(
            const Size.fromWidth(3000),
            ResponsiveBuilder<String>(
              lg: 'lg',
              builder: (context, text) => Text(text),
            ),
          ),
        );

        expect(find.text('lg'), findsOneWidget);
      });

      testWidgets('fallbacks to "sm" breakpoint when "xs" is missing', (tester) async {
        await tester.pumpWidget(
          buildApp(
            const Size.fromWidth(100),
            ResponsiveBuilder<String>(
              sm: 'sm',
              md: 'md',
              lg: 'lg',
              builder: (context, text) => Text(text),
            ),
          ),
        );

        expect(find.text('sm'), findsOneWidget);
      });

      testWidgets('fallbacks to "md" breakpoint when "xs" and "sm" is missing', (tester) async {
        await tester.pumpWidget(
          buildApp(
            const Size.fromWidth(700),
            ResponsiveBuilder<String>(
              md: 'md',
              lg: 'lg',
              builder: (context, text) => Text(text),
            ),
          ),
        );

        expect(find.text('md'), findsOneWidget);
      });

      testWidgets('fallbacks to "xs" breakpoint when "sm" is missing', (tester) async {
        await tester.pumpWidget(
          buildApp(
            const Size.fromWidth(700),
            ResponsiveBuilder<String>(
              xs: 'xs',
              md: 'md',
              lg: 'lg',
              builder: (context, text) => Text(text),
            ),
          ),
        );

        expect(find.text('xs'), findsOneWidget);
      });

      testWidgets('fallbacks to "sm" breakpoint when "md" is missing', (tester) async {
        await tester.pumpWidget(
          buildApp(
            const Size.fromWidth(1300),
            ResponsiveBuilder<String>(
              xs: 'xs',
              sm: 'sm',
              lg: 'lg',
              builder: (context, text) => Text(text),
            ),
          ),
        );

        expect(find.text('sm'), findsOneWidget);
      });

      testWidgets('fallbacks to "md" breakpoint when "lg" is missing', (tester) async {
        await tester.pumpWidget(
          buildApp(
            const Size.fromWidth(1500),
            ResponsiveBuilder<String>(
              xs: 'xs',
              sm: 'sm',
              md: 'md',
              builder: (context, text) => Text(text),
            ),
          ),
        );

        expect(find.text('md'), findsOneWidget);
      });

      testWidgets('fallbacks to "lg" breakpoint when screen size is larger than "lg"', (
        tester,
      ) async {
        await tester.pumpWidget(
          buildApp(
            const Size.fromWidth(3000),
            ResponsiveBuilder<String>(
              md: 'md',
              lg: 'lg',
              builder: (context, text) => Text(text),
            ),
          ),
        );

        expect(find.text('lg'), findsOneWidget);
      });
    });
  });
}
