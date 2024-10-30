import 'package:catalyst_voices/widgets/toggles/voices_checkbox.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    'Interactions',
    () {
      testWidgets(
        'tapping label triggers change callback',
        (tester) async {
          // Given
          const labelText = 'Label';

          var isChecked = false;
          const expectedIsChecked = true;

          final widget = Directionality(
            textDirection: TextDirection.ltr,
            child: Theme(
              data: ThemeData(
                extensions: const [VoicesColorScheme.optional()],
              ),
              child: Material(
                child: VoicesCheckbox(
                  value: isChecked,
                  onChanged: (value) {
                    isChecked = value;
                  },
                  label: const Text(labelText),
                ),
              ),
            ),
          );

          // When
          await tester.pumpWidget(widget);

          await tester.tap(find.text(labelText));

          // Then
          expect(isChecked, expectedIsChecked);
        },
      );
    },
  );
}
