import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'VoicesCheckboxGroupElement',
    () {
      test(
        'throws assert error when label and note is null',
        () {
          expect(
            () => VoicesCheckboxGroupElement(value: 1),
            throwsA(isA<AssertionError>()),
          );
        },
      );

      test(
        'returns normally when label is set',
        () {
          expect(
            () => const VoicesCheckboxGroupElement(
              value: 1,
              label: Text('Label'),
            ),
            returnsNormally,
          );
        },
      );

      test(
        'throws assert error when label and note is null',
        () {
          expect(
            () => const VoicesCheckboxGroupElement(
              value: 1,
              note: Text('Note'),
            ),
            returnsNormally,
          );
        },
      );
    },
  );

  group(
    'VoicesCheckboxGroup',
    () {
      testWidgets(
        'name is displayed as a Text',
        (tester) async {
          // Given
          const groupName = 'Select all';
          final widget = Directionality(
            textDirection: TextDirection.ltr,
            child: Theme(
              data: ThemeData(
                extensions: const [VoicesColorScheme.optional()],
              ),
              child: Material(
                child: VoicesCheckboxGroup<int>(
                  name: const Text(groupName),
                  elements: const [
                    VoicesCheckboxGroupElement(value: 0, label: Text('Label')),
                  ],
                  selected: const <int>{},
                ),
              ),
            ),
          );

          // When
          await tester.pumpWidget(widget);

          // Then
          expect(find.text(groupName), findsOneWidget);
        },
      );

      testWidgets(
        'all elements are mapped into widgets',
        (tester) async {
          // Given
          const elements = [
            VoicesCheckboxGroupElement(value: 0, label: Text('Label')),
            VoicesCheckboxGroupElement(value: 1, label: Text('Label')),
            VoicesCheckboxGroupElement(value: 2, label: Text('Label')),
            VoicesCheckboxGroupElement(value: 3, label: Text('Label')),
          ];

          final widget = Directionality(
            textDirection: TextDirection.ltr,
            child: Theme(
              data: ThemeData(
                extensions: const [VoicesColorScheme.optional()],
              ),
              child: Material(
                child: VoicesCheckboxGroup<int>(
                  name: const Text('Select all'),
                  elements: elements,
                  selected: const <int>{},
                ),
              ),
            ),
          );

          // When
          await tester.pumpWidget(widget);

          // Then
          expect(
            find.byType(VoicesCheckbox),
            findsExactly(elements.length + 1),
          );
        },
      );

      testWidgets(
        'every element has gap',
        (tester) async {
          // Given
          const elements = [
            VoicesCheckboxGroupElement(value: 0, label: Text('Label')),
            VoicesCheckboxGroupElement(value: 1, label: Text('Label')),
            VoicesCheckboxGroupElement(value: 2, label: Text('Label')),
            VoicesCheckboxGroupElement(value: 3, label: Text('Label')),
          ];

          final widget = Directionality(
            textDirection: TextDirection.ltr,
            child: Theme(
              data: ThemeData(
                extensions: const [VoicesColorScheme.optional()],
              ),
              child: Material(
                child: VoicesCheckboxGroup<int>(
                  name: const Text('Select all'),
                  elements: elements,
                  selected: const <int>{},
                ),
              ),
            ),
          );

          // When
          await tester.pumpWidget(widget);

          // Then
          expect(
            find.byWidgetPredicate(
              (widget) => widget is SizedBox && widget.height == 16,
            ),
            findsExactly(elements.length),
          );
        },
      );

      testWidgets(
        'tapping group name should select all elements',
        (tester) async {
          // Given
          const groupName = 'Select all';
          const elements = [
            VoicesCheckboxGroupElement(value: 0, label: Text('Label')),
            VoicesCheckboxGroupElement(value: 1, label: Text('Label')),
            VoicesCheckboxGroupElement(value: 2, label: Text('Label')),
            VoicesCheckboxGroupElement(value: 3, label: Text('Label')),
          ];

          final selectedElements = <int>{};
          final expectedSelections = {0, 1, 2, 3};

          final widget = Directionality(
            textDirection: TextDirection.ltr,
            child: Theme(
              data: ThemeData(
                extensions: const [VoicesColorScheme.optional()],
              ),
              child: Material(
                child: VoicesCheckboxGroup<int>(
                  name: const Text(groupName),
                  elements: elements,
                  selected: const <int>{},
                  onChanged: (value) {
                    selectedElements
                      ..clear()
                      ..addAll(value);
                  },
                ),
              ),
            ),
          );

          // When
          await tester.pumpWidget(widget);

          await tester.tap(find.text(groupName));

          // Then
          expect(
            selectedElements,
            expectedSelections,
          );
        },
      );
    },
  );
}
