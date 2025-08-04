import 'package:equatable/equatable.dart';

final class DocumentImportInvalidDataException with EquatableMixin implements Exception {
  final Object error;

  const DocumentImportInvalidDataException(this.error);

  @override
  List<Object?> get props => [error];

  @override
  String toString() => 'DocumentImportInvalidDataException(error=$error)';
}
