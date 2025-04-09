import 'package:equatable/equatable.dart';

/// A comparable range between [min] and [max].
///
/// Both [min] and [max] must be constrained.
class ComparableRange<T extends Comparable<T>> extends Equatable {
  /// The minimum range value (inclusive).
  final T min;

  /// The maximum range value (inclusive).
  final T max;

  const ComparableRange({
    required this.min,
    required this.max,
  });

  @override
  List<Object?> get props => [min, max];

  /// Returns true if this range contains the [value], false otherwise.
  bool contains(T value) {
    final min = this.min;
    final max = this.max;

    return min.compareTo(value) <= 0 && max.compareTo(value) >= 0;
  }
}

/// An open range between [min] and [max].
///
/// Both [min] and [max] might be unconstrained,
/// this allows to create ranges like:
///
/// - <-∞, ∞> // from minus infinity to infinity (practically all values).
/// - <0, ∞> // from zero to infinity (negative values are not accepted).
/// - <-∞, 0> // from minus infinity to zero (positive values are not accepted).
class NumRange<T extends num> extends Equatable {
  /// The minimum range value (inclusive).
  ///
  /// `null` means that the [min] is not constrained.
  final T? min;

  /// The maximum range value (inclusive).
  ///
  /// `null` means that the [max] is not constrained.
  final T? max;

  const NumRange({
    required this.min,
    required this.max,
  });

  @override
  List<Object?> get props => [min, max];

  /// Returns true if this range contains the [value], false otherwise.
  bool contains(T value) {
    final min = this.min;
    final max = this.max;

    if (min == null && max == null) {
      // infinite range contains every possible value
      return true;
    } else if (min != null && max != null) {
      return min.compareTo(value) <= 0 && max.compareTo(value) >= 0;
    } else if (min != null) {
      return min.compareTo(value) <= 0;
    } else if (max != null) {
      return max.compareTo(value) >= 0;
    } else {
      throw UnsupportedError('All possible combinations were checked, '
          'this line should never be executed');
    }
  }

  /// Creates a [NumRange] which assumes if
  /// [min] or [max] are null then they are unconstrained.
  static NumRange<T>? optionalRangeOf<T extends num>({T? min, T? max}) {
    if (min == null && max == null) {
      return null;
    }

    return NumRange(min: min, max: max);
  }
}
