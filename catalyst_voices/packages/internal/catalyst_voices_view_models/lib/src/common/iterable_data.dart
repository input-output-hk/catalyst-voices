import 'package:equatable/equatable.dart';

/// A wrapper around an [Iterable] that provides proper equality comparison.
final class IterableData<T extends Iterable<Object?>> extends Equatable {
  final T value;

  const IterableData(this.value);

  @override
  List<Object?> get props => [value];
}
