import 'package:flutter/services.dart';

/// A [TextInputFormatter] which only allows to enter text which can be parsed as [double].
final class DecimalTextInputFormatter extends TextInputFormatter {
  final int? maxDecimalDigits;

  const DecimalTextInputFormatter({
    this.maxDecimalDigits,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Normalize commas to dots for consistency
    final normalizedValue = newValue.copyWith(
      text: newValue.text.replaceAll(',', '.'),
    );

    // Allow only digits and a single dot
    final regex = RegExp(r'^\d*\.?\d*$');
    if (!regex.hasMatch(normalizedValue.text)) {
      return oldValue;
    }

    // Enforce max decimal digits
    final maxDecimalDigits = this.maxDecimalDigits;
    if (maxDecimalDigits != null && maxDecimalDigits >= 0 && normalizedValue.text.contains('.')) {
      final separatorIndex = normalizedValue.text.indexOf('.');
      if (separatorIndex >= 0) {
        if (maxDecimalDigits == 0) {
          return oldValue;
        }

        final decimalPartWithSeparator = normalizedValue.text.substring(separatorIndex);
        if (decimalPartWithSeparator.length > maxDecimalDigits + 1) {
          return oldValue;
        }
      }
    }

    return normalizedValue;
  }
}
