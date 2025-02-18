import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class DocumentRef extends Equatable {
  final String id;
  final String? version;

  const DocumentRef({
    required this.id,
    this.version,
  });

  bool get isExact => version != null;

  DocumentRef copyWith({
    String? id,
    Optional<String>? version,
  }) {
    return DocumentRef(
      id: id ?? this.id,
      version: version.dataOr(this.version),
    );
  }

  @override
  String toString() =>
      isExact ? 'ExactDocumentRef($id.v$version)' : 'LooseDocumentRef($id)';

  @override
  List<Object?> get props => [id, version];
}

final class SecuredDocumentRef extends Equatable {
  final DocumentRef ref;
  final String hash;

  const SecuredDocumentRef({
    required this.ref,
    required this.hash,
  });

  @override
  List<Object?> get props => [ref, hash];
}
