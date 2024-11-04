import 'package:catalyst_voices/widgets/common/label_decorator.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Label', () {
    testWidgets(
      'has correct DefaultTextStyle',
      (tester) async {
        // Given
        const bodyLargeStyle = TextStyle(
          fontSize: 24,
          color: Colors.red,
        );
        const colors = VoicesColorScheme.optional(textPrimary: Colors.black);
        final widget = Directionality(
          textDirection: TextDirection.ltr,
          child: Theme(
            data: ThemeData(
              textTheme: const TextTheme(
                bodyLarge: bodyLargeStyle,
              ),
              extensions: const [colors],
            ),
            child: const LabelDecorator(
              label: Text('Label'),
              child: Text('Child'),
            ),
          ),
        );

        // When
        await tester.pumpWidget(widget);

        // Then
        expect(
          find.byWidgetPredicate(
            (widget) {
              return widget is DefaultTextStyle &&
                  widget.style.fontSize == bodyLargeStyle.fontSize &&
                  widget.style.color == colors.textPrimary;
            },
          ),
          findsOneWidget,
        );
      },
    );
  });

  group('Note', () {
    testWidgets(
      'has correct DefaultTextStyle',
      (tester) async {
        // Given
        const bodySmallStyle = TextStyle(
          fontSize: 12,
          color: Colors.red,
        );
        const colors = VoicesColorScheme.optional(textPrimary: Colors.black);
        final widget = Directionality(
          textDirection: TextDirection.ltr,
          child: Theme(
            data: ThemeData(
              textTheme: const TextTheme(
                bodyLarge: bodySmallStyle,
              ),
              extensions: const [colors],
            ),
            child: const LabelDecorator(
              label: Text('Label'),
              child: Text('Child'),
            ),
          ),
        );

        // When
        await tester.pumpWidget(widget);

        // Then
        expect(
          find.byWidgetPredicate(
            (widget) {
              return widget is DefaultTextStyle &&
                  widget.style.fontSize == bodySmallStyle.fontSize &&
                  widget.style.color == colors.textPrimary;
            },
          ),
          findsOneWidget,
        );
      },
    );
  });

  group('Spacing', () {
    testWidgets(
      'first decorator have 4 spacing between child',
      (tester) async {
        // Given
        final widget = Directionality(
          textDirection: TextDirection.ltr,
          child: Theme(
            data: ThemeData(
              extensions: const [VoicesColorScheme.optional()],
            ),
            child: const LabelDecorator(
              label: Text('Label'),
              child: Text('Child'),
            ),
          ),
        );

        // When
        await tester.pumpWidget(widget);

        // Then
        expect(
          find.byWidgetPredicate(
            (widget) {
              return widget is SizedBox && widget.width == 4.0;
            },
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'second decorator have 8 spacing between previous decorator',
      (tester) async {
        // Given
        final widget = Directionality(
          textDirection: TextDirection.ltr,
          child: Theme(
            data: ThemeData(
              extensions: const [VoicesColorScheme.optional()],
            ),
            child: const LabelDecorator(
              label: Text('Label'),
              note: Text('Note'),
              child: Text('Child'),
            ),
          ),
        );

        // When
        await tester.pumpWidget(widget);

        // Then
        expect(
          find.byWidgetPredicate(
            (widget) {
              return widget is SizedBox && widget.width == 8.0;
            },
          ),
          findsOneWidget,
        );
      },
    );
  });
}
