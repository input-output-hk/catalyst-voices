import 'package:equatable/equatable.dart';

/// Exception for invalid cose format detected.
final class CoseFormatException extends Equatable implements Exception {
  /// The exception details, human readable.
  final String message;

  /// The default constructor for the [CoseFormatException].
  const CoseFormatException(this.message);

  @override
  List<Object?> get props => [message];

  @override
  String toString() => message;
}
