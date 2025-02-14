import 'package:catalyst_voices/widgets/dropdown/voices_dropdown_category.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final items = [
    const DropdownMenuViewModel(
      name: 'Item 1',
      value: 'value1',
      isSelected: false,
    ),
    const DropdownMenuViewModel(
      name: 'Item 2',
      value: 'value2',
      isSelected: true,
    ),
  ];

  group(VoicesDropdownCategory, () {
    testWidgets('$VoicesDropdownCategory renders correctly',
        (WidgetTester tester) async {
      final popupMenuButtonKey = GlobalKey<PopupMenuButtonState<dynamic>>();
      String? selectedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VoicesDropdownCategory(
              items: items,
              popupMenuButtonKey: popupMenuButtonKey,
              highlightColor: Colors.blue,
              onSelected: (value) {
                selectedValue = value;
              },
              child: const Text('Dropdown'),
            ),
          ),
        ),
      );

      expect(find.text('Dropdown'), findsOneWidget);

      await tester.tap(find.text('Dropdown'));
      await tester.pumpAndSettle();

      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);

      await tester.tap(find.text('Item 1'));
      await tester.pumpAndSettle();
      expect(selectedValue, equals('value1'));
    });

    testWidgets('$VoicesDropdownCategory handles callbacks',
        (WidgetTester tester) async {
      final popupMenuButtonKey = GlobalKey<PopupMenuButtonState<dynamic>>();
      var wasOpened = false;
      var wasCanceled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VoicesDropdownCategory(
              items: items,
              popupMenuButtonKey: popupMenuButtonKey,
              onOpened: () {
                wasOpened = true;
              },
              onCanceled: () {
                wasCanceled = true;
              },
              child: const Text('Dropdown'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Dropdown'));
      await tester.pumpAndSettle();
      expect(wasOpened, isTrue);

      await tester.tapAt(Offset.zero);
      expect(wasCanceled, isTrue);
    });

    testWidgets('$VoicesDropdownCategory applies highlight color',
        (WidgetTester tester) async {
      final popupMenuButtonKey = GlobalKey<PopupMenuButtonState<dynamic>>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VoicesDropdownCategory(
              items: items,
              popupMenuButtonKey: popupMenuButtonKey,
              highlightColor: Colors.blue,
              child: const Text('Dropdown'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Dropdown'));
      await tester.pumpAndSettle();

      final containerFinder = find.ancestor(
        of: find.text('Item 2'),
        matching: find.byType(Container),
      );
      final container = tester.widget<Container>(containerFinder);
      expect(container.color, equals(Colors.blue));
    });
  });
}
