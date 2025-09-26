import 'dart:math';

abstract final class NumberUtils {
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
