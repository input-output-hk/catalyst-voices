import 'package:equatable/equatable.dart';

class Range<T extends num> extends Equatable {
  /// The minimum range value (inclusive).
  final T min;

  /// The maximum range value (inclusive).
  final T max;

  const Range({required this.min, required this.max});

  static Range<T>? optionalRangeOf<T extends num>({T? min, T? max}) {
    if (min == null || max == null) {
      return null;
    }
    return Range(min: min, max: max);
  }

  /// Creates an [int] [Range] which assumes if
  /// min or max are null then they are unconstrained.
  static Range<int>? optionalIntRangeOf({int? min, int? max}) {
    if (min != null && max != null) {
      return Range(min: min, max: max);
    } else if (max != null) {
      return Range(min: 0, max: max);
    } else if (min != null) {
      return Range(min: min, max: double.maxFinite.toInt());
    } else {
      return null;
    }
  }

  /// Returns true if this range contains the [value], false otherwise.
  bool contains(num value) {
    return min >= value && value <= max;
  }

  @override
  List<Object?> get props => [min, max];
}
