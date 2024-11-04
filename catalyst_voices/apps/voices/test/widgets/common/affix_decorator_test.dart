import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Prefix', () {
    testWidgets(
      'is visible when not null ',
      (tester) async {
        // Given
        const closeIcon = Icon(Icons.close);
        const affixDecorator = Directionality(
          textDirection: TextDirection.ltr,
          child: AffixDecorator(
            prefix: closeIcon,
            child: Text('Label'),
          ),
        );

        // When
        await tester.pumpWidget(affixDecorator);

        // Then
        expect(find.byIcon(Icons.close), findsOneWidget);
      },
    );

    testWidgets(
      'iconTheme is applied to the prefix icon',
      (tester) async {
        // Given
        const closeIcon = Icon(Icons.close);
        const iconTheme = IconThemeData(color: Colors.yellow);
        const affixDecorator = Directionality(
          textDirection: TextDirection.ltr,
          child: AffixDecorator(
            iconTheme: iconTheme,
            prefix: closeIcon,
            child: Text('Label'),
          ),
        );

        // When
        await tester.pumpWidget(affixDecorator);

        // Then
        final iconFinder = find.byIcon(Icons.close);

        expect(iconFinder, findsOneWidget);
        expect(
          (tester.firstWidget(find.byType(IconTheme)) as IconTheme).data.color,
          allOf(
            isNotNull,
            equals(iconTheme.color),
          ),
        );
      },
    );

    testWidgets(
      'gap is present and default correctly',
      (tester) async {
        // Given
        const closeIcon = Icon(Icons.close);
        const affixDecorator = Directionality(
          textDirection: TextDirection.ltr,
          child: AffixDecorator(
            prefix: closeIcon,
            child: Text('Label'),
          ),
        );

        // When
        await tester.pumpWidget(affixDecorator);

        // Then
        final iconFinder = find.byIcon(Icons.close);
        final gapFinder = find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.width == 8.0,
        );

        expect(iconFinder, findsOneWidget);
        expect(gapFinder, findsOneWidget);
      },
    );
  });

  group('Child', () {
    testWidgets(
      'is wrapped in flexible widget',
      (tester) async {
        // Given
        const affixDecorator = Directionality(
          textDirection: TextDirection.ltr,
          child: AffixDecorator(child: Text('Label')),
        );

        // When
        await tester.pumpWidget(affixDecorator);

        // Then
        final flexibleFinder = find.byType(Flexible);

        expect(flexibleFinder, findsOneWidget);
      },
    );
  });

  group('Suffix', () {
    testWidgets(
      'is visible when not null ',
      (tester) async {
        // Given
        const closeIcon = Icon(Icons.close);
        const affixDecorator = Directionality(
          textDirection: TextDirection.ltr,
          child: AffixDecorator(
            suffix: closeIcon,
            child: Text('Label'),
          ),
        );

        // When
        await tester.pumpWidget(affixDecorator);

        // Then
        expect(find.byIcon(Icons.close), findsOneWidget);
      },
    );

    testWidgets(
      'iconTheme is applied to the suffix icon',
      (tester) async {
        // Given
        const closeIcon = Icon(Icons.close);
        const iconTheme = IconThemeData(color: Colors.yellow);
        const affixDecorator = Directionality(
          textDirection: TextDirection.ltr,
          child: AffixDecorator(
            iconTheme: iconTheme,
            suffix: closeIcon,
            child: Text('Label'),
          ),
        );

        // When
        await tester.pumpWidget(affixDecorator);

        // Then
        final iconFinder = find.byIcon(Icons.close);

        expect(iconFinder, findsOneWidget);
        expect(
          (tester.firstWidget(find.byType(IconTheme)) as IconTheme).data.color,
          allOf(
            isNotNull,
            equals(iconTheme.color),
          ),
        );
      },
    );

    testWidgets(
      'gap is present and default correctly',
      (tester) async {
        // Given
        const closeIcon = Icon(Icons.close);
        const affixDecorator = Directionality(
          textDirection: TextDirection.ltr,
          child: AffixDecorator(
            suffix: closeIcon,
            child: Text('Label'),
          ),
        );

        // When
        await tester.pumpWidget(affixDecorator);

        // Then
        final iconFinder = find.byIcon(Icons.close);
        final gapFinder = find.byWidgetPredicate(
          (widget) => widget is SizedBox && widget.width == 8.0,
        );

        expect(iconFinder, findsOneWidget);
        expect(gapFinder, findsOneWidget);
      },
    );
  });
}
