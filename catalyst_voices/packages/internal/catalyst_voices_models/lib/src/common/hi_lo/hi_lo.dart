import 'package:equatable/equatable.dart';

/// Abstract HiLo pattern representation.
abstract base class HiLo<T extends Object> extends Equatable {
  final T high;
  final T low;

  const HiLo({
    required this.high,
    required this.low,
  });

  @override
  List<Object?> get props => [high, low];
}
