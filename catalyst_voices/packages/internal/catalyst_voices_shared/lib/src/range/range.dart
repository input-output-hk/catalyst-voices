import 'package:equatable/equatable.dart';

/// A comparable range between [min] and [max].
class Range<T extends Comparable<dynamic>?> extends Equatable {
  /// The minimum range value (inclusive).
  ///
  /// If [T] is nullable and [min] is `null` then it means the range is not min-constrained.
  final T min;

  /// The maximum range value (inclusive).
  ///
  /// If [T] is nullable and [max] is `null` then it means the range is not max-constrained.
  final T max;

  const Range({
    required this.min,
    required this.max,
  });

  @override
  List<Object?> get props => [min, max];

  /// Returns true if this range contains the [value], false otherwise.
  bool contains(T value) {
    final min = this.min;
    final max = this.max;

    final minOk = min == null || min.compareTo(value) <= 0;
    final maxOk = max == null || max.compareTo(value) >= 0;

    return minOk && maxOk;
  }

  /// Creates a [Range] which assumes if
  /// [min] or [max] are null then they are unconstrained.
  static Range<T?>? optionalRangeOf<T extends Comparable<dynamic>?>({T? min, T? max}) {
    if (min == null && max == null) {
      return null;
    }

    return Range<T?>(min: min, max: max);
  }
}
