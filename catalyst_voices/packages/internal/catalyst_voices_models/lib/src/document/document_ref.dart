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

  /// Generates a draft version of the document reference.
  ///
  /// The version can be used as next version for updated document,
  /// i.e. by proposal builder.
  DraftRef nextVersion();
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
  DraftRef nextVersion() => this;

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

  factory SignedDocumentRef.generateFirstRef() {
    final id = const Uuid().v7();
    return SignedDocumentRef(
      id: id,
      version: id,
    );
  }

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
  DraftRef nextVersion() {
    return DraftRef(
      id: id,
      version: const Uuid().v7(),
    );
  }

  @override
  String toString() => isExact
      ? 'ExactSignedDocumentRef($id.v$version)'
      : 'LooseSignedDocumentRef($id)';
}
