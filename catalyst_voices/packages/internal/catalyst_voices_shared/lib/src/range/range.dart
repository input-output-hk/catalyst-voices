import 'package:equatable/equatable.dart';

/// A numerical range between [min] and [max].
///
/// Both [min] and [max] might be unconstrained,
/// this allows to create ranges like:
///
/// - <-∞, ∞> // from minus infinity to infinity (practically all values).
/// - <0, ∞> // from zero to infinity (negative values are not accepted).
/// - <-∞, 0> // from minus infinity to zero (positive values are not accepted).
class Range<T extends num> extends Equatable {
  /// The minimum range value (inclusive).
  ///
  /// `null` means that the [min] is not constrained.
  final T? min;

  /// The maximum range value (inclusive).
  ///
  /// `null` means that the [max] is not constrained.
  final T? max;

  const Range({
    required this.min,
    required this.max,
  });

  /// Creates an [int] [Range] which assumes if
  /// [min] or [max] are null then they are unconstrained.
  static Range<int>? optionalIntRangeOf({int? min, int? max}) {
    if (min == null && max == null) {
      return null;
    }

    return Range(min: min, max: max);
  }

  /// Returns true if this range contains the [value], false otherwise.
  bool contains(num value) {
    final min = this.min ?? double.negativeInfinity;
    final max = this.max ?? double.infinity;
    return value >= min && value <= max;
  }

  @override
  List<Object?> get props => [min, max];
}
