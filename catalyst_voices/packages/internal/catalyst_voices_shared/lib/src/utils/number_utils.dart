abstract final class NumberUtils {
  /// A decimal separator used to input fractional values.
  ///
  /// For now for simplicity no localized separators are supported like commas in some locales.
  static const String decimalSeparator = '.';

  /// The length of [String] which can be safely parsed into an [int] on all flutter platforms.
  ///
  /// The number comes from counting the length of decimally encoded max int value (2^53-1).
  static const int maxSafeIntDigits = 15;

  const NumberUtils._();

  /// Checks whether [value] is a multiple of [multipleOf] within the allowed [tolerance].
  /// The [tolerance] allows to mitigate the floating point rounding errors.
  ///
  /// Example (no tolerance):
  /// ```dart
  /// final noTolerance = isDoubleMultipleOf(
  ///   value: 5.00000005,
  ///   multipleOf: 5.00000,
  ///   tolerance: 0,
  /// );
  ///
  ///  expect(noTolerance, isFalse);
  /// ```
  /// 
  /// Example (with tolerance):
  /// ```dart
  /// final withTolerance = isDoubleMultipleOf(
  ///   value: 5.00000005,
  ///   multipleOf: 5.00000,
  ///   tolerance: 1e-9,
  /// );
  ///
  ///  expect(withTolerance, isTrue);
  /// ```
  static bool isDoubleMultipleOf({
    required double value,
    required double multipleOf,
    double tolerance = 1e-9,
  }) {
    // avoid division by zero
    if (multipleOf == 0) {
      return false;
    }

    final ratio = value / multipleOf;
    return (ratio - ratio.round()).abs() < tolerance;
  }
}

extension StringDoubleExt on String {
  /// Converts commas into dots.
  /// Remains the last dot in the string, removes others.
  String normalizeDecimalSeparator() {
    return replaceAll(',', NumberUtils.decimalSeparator).replaceAll(RegExp(r'\.(?=.*\.)'), '');
  }
}
