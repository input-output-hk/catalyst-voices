import 'package:equatable/equatable.dart';

class Range<T extends num> extends Equatable {
  final T min;
  final T max;

  const Range({required this.min, required this.max});

  static Range<T>? optionalRangeOf<T extends num>({T? min, T? max}) {
    if (min == null || max == null) {
      return null;
    }
    return Range(min: min, max: max);
  }

  @override
  List<Object?> get props => [min, max];
}
