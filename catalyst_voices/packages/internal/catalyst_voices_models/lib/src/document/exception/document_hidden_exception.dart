import 'package:catalyst_voices_models/src/document/document_ref.dart';
import 'package:equatable/equatable.dart';

/// A document is hidden and should not be accessed.
final class DocumentHiddenException with EquatableMixin implements Exception {
  final DocumentRef ref;

  const DocumentHiddenException({required this.ref});

  @override
  List<Object?> get props => [ref];

  @override
  String toString() => 'DocumentHiddenException(ref: $ref)';
}
