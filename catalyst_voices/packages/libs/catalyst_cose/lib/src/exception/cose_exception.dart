import 'package:equatable/equatable.dart';

/// A generalized COSE sign exception.
final class CoseSignException extends Equatable implements Exception {
  /// A message describing the exception.
  final String message;

  /// The source of the exception, if any.
  final Object? source;

  /// The default constructor for the [CoseSignException].
  const CoseSignException({
    required this.message,
    this.source,
  });

  @override
  List<Object?> get props => [message, source];
}
