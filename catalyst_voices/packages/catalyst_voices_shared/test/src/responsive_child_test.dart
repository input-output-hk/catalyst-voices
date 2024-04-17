import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget buildApp(Size size) => MediaQuery(
        data: MediaQueryData(size: size),
        child: MaterialApp(
          home: Scaffold(
            body: ResponsiveChild(
              xs: (context) =>
                  const Text('Simple text for extra small screens.'),
              sm: (context) => const Padding(
                padding: EdgeInsets.all(50),
                child: Text('Text with padding for small screens.'),
              ),
              md: (context) => const Column(
                children: [
                  Text('This is'),
                  Text('a set'),
                  Text('of Texts'),
                  Text('for medium screens.'),
                ],
              ),
              other: (context) => const Text('The fallback widget.'),
            ),
          ),
        ),
      );

  group('Test screen sizes', () {
    testWidgets('ResponsiveChild outputs a text for extra-small screens',
        (tester) async {
      await tester.pumpWidget(
        buildApp(const Size.fromWidth(280)),
      );
      final testedElement = find.byType(Text);
      expect(testedElement, findsOneWidget);
      expect(
        find.text('Simple text for extra small screens.'),
        findsOneWidget,
      );
    });
    testWidgets('ResponsiveChild outputs a text with padding for small screens',
        (tester) async {
      await tester.pumpWidget(
        buildApp(const Size.fromWidth(620)),
      );
      final testedElement = find.byType(Text);
      expect(testedElement, findsOneWidget);
      expect(
        find.text('Text with padding for small screens.'),
        findsOneWidget,
      );
      final paddingWidget = tester.widget<Padding>(
        find.ancestor(
          of: testedElement,
          matching: find.byType(Padding),
        ),
      );
      expect(paddingWidget.padding, const EdgeInsets.all(50));
    });
    testWidgets('ResponsiveChild outputs four texts for medium screens',
        (tester) async {
      await tester.pumpWidget(
        buildApp(const Size.fromWidth(1280)),
      );
      final testedElements = find.byType(Text);
      expect(testedElements, findsExactly(4));
      expect(find.text('This is'), findsOneWidget);
      expect(find.text('a set'), findsOneWidget);
      expect(find.text('of Texts'), findsOneWidget);
      expect(find.text('for medium screens.'), findsOneWidget);
    });
    testWidgets('ResponsiveChild fallback to other for large screens',
        (tester) async {
      await tester.pumpWidget(
        buildApp(const Size.fromWidth(1600)),
      );
      final testedElements = find.byType(Text);
      expect(testedElements, findsOneWidget);
      expect(find.text('The fallback widget.'), findsOneWidget);
    });
  });
}
