import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

sealed class DocumentRef extends Equatable {
  final String id;
  final String? version;

  const DocumentRef({
    required this.id,
    this.version,
  });

  factory DocumentRef.build({
    required String id,
    String? version,
    required bool isDraft,
  }) {
    return isDraft
        ? DraftRef(id: id, version: version)
        : SignedDocumentRef(id: id, version: version);
  }

  bool get isExact => version != null;

  @override
  List<Object?> get props => [id, version];

  DocumentRef copyWith({
    String? id,
    Optional<String>? version,
  });
}

final class DraftRef extends DocumentRef {
  const DraftRef({
    required super.id,
    super.version,
  });

  factory DraftRef.generateFirstRef() {
    final id = const Uuid().v7();
    return DraftRef(
      id: id,
      version: id,
    );
  }

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
