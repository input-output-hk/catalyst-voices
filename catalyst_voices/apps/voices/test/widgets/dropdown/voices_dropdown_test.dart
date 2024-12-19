import 'package:catalyst_voices/widgets/dropdown/voices_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('VoicesDropdown Widget Tests', () {
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
          body: VoicesDropdown(
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
          body: VoicesDropdown(
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
          body: VoicesDropdown(
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
          body: VoicesDropdown(
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
          body: VoicesDropdown(
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
}
