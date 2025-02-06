import 'package:catalyst_voices/widgets/toggles/voices_radio.dart';
import 'package:catalyst_voices/widgets/toggles/voices_radio_button_form.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group(VoicesRadioButtonFormField, () {
    late List<String> items;
    late VoicesColorScheme voicesColors;

    setUpAll(() {
      items = ['Item 1', 'Item 2', 'Item 3'];

      voicesColors = const VoicesColorScheme.optional(
        textDisabled: Colors.grey,
        outlineBorderVariant: Colors.blueGrey,
      );
    });

    testWidgets('initially displays with no selection', (tester) async {
      await tester.pumpApp(
        Scaffold(
          body: Center(
            child: VoicesRadioButtonFormField(
              items: items,
              value: null,
              onChanged: (_) {},
            ),
          ),
        ),
        voicesColors: voicesColors,
      );
      await tester.pumpAndSettle();

      final option1Finder = find.text('Item 1');
      final option2Finder = find.text('Item 2');
      final option3Finder = find.text('Item 3');

      expect(option1Finder, findsOneWidget);
      expect(option2Finder, findsOneWidget);
      expect(option3Finder, findsOneWidget);

      final radioButtons = find.byType(VoicesRadio<String>);
      expect(radioButtons, findsNWidgets(3));
    });

    testWidgets('updates selection when an item is tapped', (tester) async {
      String? selectedValue;
      await tester.pumpApp(
        Scaffold(
          body: Center(
            child: VoicesRadioButtonFormField(
              items: items,
              value: 'Item 1',
              onChanged: (value) {
                selectedValue = value;
              },
            ),
          ),
        ),
        voicesColors: voicesColors,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Item 2'));
      await tester.pump();

      expect(selectedValue, 'Item 2');
    });

    testWidgets('displays error message when in error state',
        (WidgetTester tester) async {
      await tester.pumpApp(
        Scaffold(
          body: Center(
            child: VoicesRadioButtonFormField(
              items: items,
              value: null,
              onChanged: (_) {},
              validator: (value) =>
                  value == null ? 'Selection is required' : null,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
          ),
        ),
        voicesColors: voicesColors,
      );
      await tester.pumpAndSettle();

      final errorTextFinder = find.text('Selection is required');
      expect(errorTextFinder, findsOneWidget);
    });
  });
}
