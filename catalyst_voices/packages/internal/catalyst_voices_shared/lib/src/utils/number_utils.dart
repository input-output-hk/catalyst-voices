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
