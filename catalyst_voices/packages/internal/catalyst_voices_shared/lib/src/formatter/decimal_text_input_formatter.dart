import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/services.dart';

/// A [TextInputFormatter] which only allows to enter text which can be parsed as [double].
final class DecimalTextInputFormatter extends TextInputFormatter {
  final int? maxIntegerDigits;
  final int? maxDecimalDigits;

  const DecimalTextInputFormatter({
    this.maxIntegerDigits,
    this.maxDecimalDigits,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Normalize commas to dots for consistency
    final normalizedValue = newValue.copyWith(
      text: newValue.text.normalizeDecimalSeparator(),
    );

    // Allow only digits and a single dot
    final regex = RegExp(r'^\d*\.?\d*$');
    if (!regex.hasMatch(normalizedValue.text)) {
      return oldValue;
    }

    // Split integer and decimal parts
    final parts = normalizedValue.text.split('.');
    final integerPart = parts.elementAt(0);
    final decimalPart = parts.elementAtOrNull(1);

    // Enforce max integer digits
    final maxIntegerDigits = this.maxIntegerDigits;
    if (maxIntegerDigits != null &&
        maxIntegerDigits >= 0 &&
        integerPart.length > maxIntegerDigits) {
      return oldValue;
    }

    // Enforce max decimal digits
    final maxDecimalDigits = this.maxDecimalDigits;
    if (maxDecimalDigits != null &&
        maxDecimalDigits >= 0 &&
        decimalPart != null &&
        decimalPart.length > maxDecimalDigits) {
      return oldValue;
    }

    // Don't allow decimal separator if decimals not allowed
    if (maxDecimalDigits == 0 && decimalPart != null) {
      return oldValue;
    }

    return normalizedValue;
  }
}
