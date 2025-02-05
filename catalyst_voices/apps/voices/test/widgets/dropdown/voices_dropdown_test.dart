import 'package:catalyst_voices/widgets/dropdown/voices_dropdown.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('$FilterByDropdown Widget Tests', () {
    late List<DropdownMenuEntry<String>> items;
    setUp(() {
      items = [
        const DropdownMenuEntry<String>(
          value: 'item1',
          label: 'Item 1',
        ),
        const DropdownMenuEntry<String>(
          value: 'item2',
          label: 'Item 2',
        ),
      ];
    });

    testWidgets('renders correctly with initial value', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: FilterByDropdown(
            items: items,
            value: 'item1',
            onChanged: (value) {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the dropdown is rendered
      expect(find.byType(DropdownMenu<String?>), findsOneWidget);

      // Find the input field showing the selected value
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is EditableText && widget.controller.text == 'Item 1',
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders correctly without initial value', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: FilterByDropdown(
            items: items,
            onChanged: (value) {},
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the dropdown is rendered
      expect(find.byType(DropdownMenu<String?>), findsOneWidget);

      // Find the input field showing the selected value
      expect(
        find.byWidgetPredicate(
          (widget) => widget is EditableText && widget.controller.text == 'All',
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders correctly without initial value', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: FilterByDropdown(
            items: items,
            onChanged: (value) {},
          ),
        ),
      );
      await tester.pumpAndSettle();
      // Verify the dropdown is rendered
      expect(find.byType(DropdownMenu<String?>), findsOneWidget);

      await tester.tap(find.byType(DropdownMenu<String?>));
      await tester.pumpAndSettle();
      // // Find the input field showing the selected value
      expect(
        find.text('All').last,
        findsOneWidget,
      );
      expect(
        find.text('Item 1').last,
        findsOneWidget,
      );
      expect(
        find.text('Item 2').last,
        findsOneWidget,
      );
    });

    testWidgets('Changes value correctly', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: FilterByDropdown(
            items: items,
            onChanged: (value) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DropdownMenu<String?>), findsOneWidget);

      // Find the input field showing the selected value
      expect(
        find.byWidgetPredicate(
          (widget) => widget is EditableText && widget.controller.text == 'All',
        ),
        findsOneWidget,
      );

      await tester.tap(find.byType(DropdownMenu<String?>));
      await tester.pumpAndSettle();
      await tester.tap(
        find.text('Item 1').last,
      );
      await tester.pumpAndSettle();
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is EditableText && widget.controller.text == 'Item 1',
        ),
        findsOneWidget,
      );
    });

    testWidgets('On change callback is called correctly', (tester) async {
      final log = <int>[];
      await tester.pumpApp(
        Scaffold(
          body: FilterByDropdown(
            items: items,
            onChanged: (value) {
              log.add(0);
            },
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(log.length, 0);
      expect(find.byType(DropdownMenu<String?>), findsOneWidget);

      // Find the input field showing the selected value
      expect(
        find.byWidgetPredicate(
          (widget) => widget is EditableText && widget.controller.text == 'All',
        ),
        findsOneWidget,
      );

      await tester.tap(find.byType(DropdownMenu<String?>));
      await tester.pumpAndSettle();
      await tester.tap(
        find.text('Item 1').last,
      );
      await tester.pumpAndSettle();
      expect(log.length, 1);
    });
  });

  group('$SingleSelectDropdown Widget Tests', () {
    late VoicesColorScheme voicesColors;

    setUp(() {
      voicesColors = const VoicesColorScheme.optional(
        textDisabled: Colors.grey,
        outlineBorderVariant: Colors.blueGrey,
      );
    });

    testWidgets(
        'SingleSelectDropdown should display hint and allow item selection',
        (WidgetTester tester) async {
      // Sample data
      final items = [
        const DropdownMenuEntry<String>(value: 'item1', label: 'Item 1'),
        const DropdownMenuEntry<String>(value: 'item2', label: 'Item 2'),
      ];
      String? selectedValue;

      await tester.pumpApp(
        Scaffold(
          body: Center(
            child: SingleSelectDropdown<String>(
              items: items,
              value: null,
              hintText: 'Select an item',
              onChanged: (value) => selectedValue = value,
            ),
          ),
        ),
        voicesColors: voicesColors,
      );
      await tester.pumpAndSettle();

      expect(find.text('Select an item'), findsOneWidget);
      expect(selectedValue, isNull);

      await tester.tap(find.byType(DropdownMenu<String>));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Item 1').last);
      await tester.pumpAndSettle();

      expect(selectedValue, equals('item1'));
    });

    testWidgets('SingleSelectDropdown should handle validation error',
        (WidgetTester tester) async {
      final items = [
        const DropdownMenuEntry<String>(value: 'item1', label: 'Item 1'),
        const DropdownMenuEntry<String>(value: 'item2', label: 'Item 2'),
      ];
      await tester.pumpApp(
        Scaffold(
          body: Center(
            child: SingleSelectDropdown<String>(
              items: items,
              value: null,
              hintText: 'Select an item',
              validator: (value) =>
                  value == 'item2' ? 'Value is invalid' : null,
              onChanged: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Try submitting form with no selection to trigger validation
      await tester.tap(find.byType(DropdownMenu<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Item 2').last);
      await tester.pumpAndSettle();

      // Check for the validation error message
      expect(find.text('Value is invalid'), findsOneWidget);
    });
  });
}
