import 'dart:math';

abstract final class NumberUtils {
  /// A decimal separator used to input fractional values.
  static const String decimalSeparator = '.';

  /// The length of [String] which can be safely parsed into an [int] on all flutter platforms.
  ///
  /// The number comes from counting the length of decimally encoded max int value (2^53-1).
  static const int maxSafeIntDigits = 15;

  const NumberUtils._();

  /// Checks whether [value] is a multiple of [multipleOf] within the allowed [tolerance].
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

extension DoubleExt on double {
  /// Truncates the double to [decimals] decimal places.
  double truncateToDecimals(int decimals) {
    assert(decimals >= 0, 'decimal places are only positive');

    final factor = pow(10, decimals).toDouble();
    return (this * factor).truncate() / factor;
  }
}

extension StringDoubleExt on String {
  /// Converts commas into dots.
  /// Remains the last dot in the string, removes others.
  String normalizeDecimalSeparator() {
    return replaceAll(',', NumberUtils.decimalSeparator).replaceAll(RegExp(r'\.(?=.*\.)'), '');
  }
}
