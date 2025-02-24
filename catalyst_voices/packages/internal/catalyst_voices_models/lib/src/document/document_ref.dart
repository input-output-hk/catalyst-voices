import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

sealed class DocumentRef extends Equatable {
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
  });

  @override
  List<Object?> get props => [id, version];
}

final class SignedDocumentRef extends DocumentRef {
  const SignedDocumentRef({
    required super.id,
    super.version,
  });

  @override
  SignedDocumentRef copyWith({
    String? id,
    Optional<String>? version,
  }) {
    return SignedDocumentRef(
      id: id ?? this.id,
      version: version.dataOr(this.version),
    );
  }

  @override
  String toString() => isExact
      ? 'ExactSignedDocumentRef($id.v$version)'
      : 'LooseSignedDocumentRef($id)';
}

final class DraftRef extends DocumentRef {
  const DraftRef({
    required super.id,
    super.version,
  });

  @override
  DraftRef copyWith({
    String? id,
    Optional<String>? version,
  }) {
    return DraftRef(
      id: id ?? this.id,
      version: version.dataOr(this.version),
    );
  }

  @override
  String toString() =>
      isExact ? 'ExactDraftRef($id.v$version)' : 'LooseDraftRef($id)';
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
