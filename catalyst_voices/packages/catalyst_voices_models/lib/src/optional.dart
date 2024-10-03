import 'package:equatable/equatable.dart';

/// Simple wrapper for any given [data].
///
/// Its useful when working with copyWith pattern and nullable fields.
/// When wrapping parameters in [Optional] its possible to clear fields.
///
/// Example:
/// ```dart
/// final class ScreenState {
///   final String? username;
///
///   ScreenState({
///     this.username,
///   });
///
///   ScreenState copyWith({
///     Optional<String>? username,
///   }) {
///     return ScreenState(
///       username: username != null ? username.data : this.username,
///     );
///   }
/// }
///```
final class Optional<T extends Object> extends Equatable {
  final T? data;

  const Optional(this.data);

  const Optional.of(T this.data);

  const Optional.empty() : data = null;

  bool get isEmpty => data == null;

  @override
  List<Object?> get props => [data];
}
