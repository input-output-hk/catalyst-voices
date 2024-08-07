import 'package:catalyst_voices/widgets/toggles/voices_checkbox_group.dart';
import 'package:flutter/widgets.dart';
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
            () => VoicesCheckboxGroupElement(
              value: 1,
              label: const Text('Label'),
            ),
            returnsNormally,
          );
        },
      );

      test(
        'throws assert error when label and note is null',
        () {
          expect(
            () => VoicesCheckboxGroupElement(
              value: 1,
              note: const Text('Note'),
            ),
            returnsNormally,
          );
        },
      );
    },
  );
}
