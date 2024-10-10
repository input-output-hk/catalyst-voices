import 'package:catalyst_voices/common/formatters/input_formatters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(NoWhitespacesFormatter, () {
    test('spaces are not allowed', () {
      // Given
      const oldValue = TextEditingValue(text: 'qqq');
      const newValue = TextEditingValue(text: 'qqq  ');

      const expectedValue = TextEditingValue(text: 'qqq');

      final formatter = NoWhitespacesFormatter();

      // When
      final value = formatter.formatEditUpdate(oldValue, newValue);

      // Then
      expect(value, expectedValue);
    });

    test('upper case is allowed', () {
      // Given
      const oldValue = TextEditingValue(text: 'qqq');
      const newValue = TextEditingValue(text: 'QQQ');

      const expectedValue = TextEditingValue(text: 'QQQ');

      final formatter = NoWhitespacesFormatter();

      // When
      final value = formatter.formatEditUpdate(oldValue, newValue);

      // Then
      expect(value, expectedValue);
    });
  });
}
