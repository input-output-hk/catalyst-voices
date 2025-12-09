import 'package:equatable/equatable.dart';

/// An exception denoting a problem with signed document creation.
class DocumentSignException extends Equatable implements Exception {
  final String message;

  const DocumentSignException(this.message);

  @override
  List<Object?> get props => [message];
}
