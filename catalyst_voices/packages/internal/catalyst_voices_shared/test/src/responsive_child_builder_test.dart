import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(ResponsiveChildBuilder, () {
    Widget buildApp(Size size) => MediaQuery(
      data: MediaQueryData(size: size),
      child: MaterialApp(
        home: Scaffold(
          body: ResponsiveChildBuilder(
            xs: (_) => const Text('xs'),
            sm: (_) => const Text('sm'),
            md: (_) => const Text('md'),
            lg: (_) => const Text('lg'),
          ),
        ),
      ),
    );

    testWidgets('outputs a text for extra-small screens', (tester) async {
      await tester.pumpWidget(
        buildApp(const Size.fromWidth(280)),
      );
      expect(find.text('xs'), findsOneWidget);
    });

    testWidgets('outputs a text with padding for small screens', (tester) async {
      await tester.pumpWidget(
        buildApp(const Size.fromWidth(620)),
      );
      expect(find.text('sm'), findsOneWidget);
    });

    testWidgets('outputs four texts for medium screens', (tester) async {
      await tester.pumpWidget(
        buildApp(const Size.fromWidth(1280)),
      );
      expect(find.text('md'), findsOneWidget);
    });

    testWidgets('fallback to other for large screens', (tester) async {
      await tester.pumpWidget(
        buildApp(const Size.fromWidth(1600)),
      );
      expect(find.text('lg'), findsOneWidget);
    });
  });
}
