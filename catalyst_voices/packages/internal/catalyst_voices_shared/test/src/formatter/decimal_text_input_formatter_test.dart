import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(DecimalTextInputFormatter, () {
    test('allows valid integer input', () {
      const formatter = DecimalTextInputFormatter(maxIntegerDigits: 5);
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: '12345');

      final result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, '12345');
    });

    test('rejects integer exceeding maxIntegerDigits', () {
      const formatter = DecimalTextInputFormatter(maxIntegerDigits: 3);
      const oldValue = TextEditingValue(text: '123');
      const newValue = TextEditingValue(text: '1234');

      final result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, '123'); // oldValue returned
    });

    test('allows valid decimal input', () {
      const formatter = DecimalTextInputFormatter(maxDecimalDigits: 2);
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: '12.34');

      final result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, '12.34');
    });

    test('rejects decimal exceeding maxDecimalDigits', () {
      const formatter = DecimalTextInputFormatter(maxDecimalDigits: 2);
      const oldValue = TextEditingValue(text: '12.34');
      const newValue = TextEditingValue(text: '12.345');

      final result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, '12.34');
    });

    test('rejects invalid characters', () {
      const formatter = DecimalTextInputFormatter();
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: '12a34');

      final result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, '');
    });

    test('respects thousands separator', () {
      const formatter = DecimalTextInputFormatter(maxDecimalDigits: 2);
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue(text: '12,34');

      final result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, '1234');
    });

    test('rejects decimal if maxDecimalDigits is 0', () {
      const formatter = DecimalTextInputFormatter(maxDecimalDigits: 0);
      const oldValue = TextEditingValue(text: '123');
      const newValue = TextEditingValue(text: '123.4');

      final result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, '123'); // oldValue returned
    });

    test('allows empty string', () {
      const formatter = DecimalTextInputFormatter(maxIntegerDigits: 3, maxDecimalDigits: 2);
      const oldValue = TextEditingValue.empty;
      const newValue = TextEditingValue.empty;

      final result = formatter.formatEditUpdate(oldValue, newValue);

      expect(result.text, '');
    });
  });
}
