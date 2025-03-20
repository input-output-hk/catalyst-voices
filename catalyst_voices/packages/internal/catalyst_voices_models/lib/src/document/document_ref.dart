import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid_plus/uuid_plus.dart';

sealed class DocumentRef extends Equatable implements Comparable<DocumentRef> {
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

  /// Whether the ref specifies the document [version].
  bool get isExact => version != null;

  @override
  List<Object?> get props => [id, version];

  @override
  int compareTo(DocumentRef other) {
    final dateTime = version?.tryDateTime;
    final otherDateTime = other.version?.tryDateTime;

    if (dateTime != null && otherDateTime != null) {
      return dateTime.compareTo(otherDateTime);
    }

    if (dateTime != null && otherDateTime == null) {
      return 1;
    }

    if (dateTime == null && otherDateTime != null) {
      return -1;
    }

    return 0;
  }

  DocumentRef copyWith({
    String? id,
    Optional<String>? version,
  });

  /// Generates a draft version of the document reference.
  ///
  /// The version can be used as next version for updated document,
  /// i.e. by proposal builder.
  DraftRef nextVersion();

  /// Creates ref without version.
  DocumentRef toLoose();

  /// Converts the [DocumentRef] to [SignedDocumentRef].
  ///
  /// Useful when a draft becomes a signed document after publishing.
  SignedDocumentRef toSignedDocumentRef();
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
  DraftRef toLoose() => copyWith(version: const Optional.empty());

  @override
  SignedDocumentRef toSignedDocumentRef() => SignedDocumentRef(
        id: id,
        version: version,
      );

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

  const SignedDocumentRef.exact({
    required super.id,
    required String super.version,
  });

  /// Creates ref for first version of [id] document.
  const SignedDocumentRef.first(String id) : this(id: id, version: id);

  factory SignedDocumentRef.generateFirstRef() {
    final id = const Uuid().v7();
    return SignedDocumentRef(
      id: id,
      version: id,
    );
  }

  const SignedDocumentRef.loose({required super.id});

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
  SignedDocumentRef toLoose() => copyWith(version: const Optional.empty());

  @override
  SignedDocumentRef toSignedDocumentRef() => this;

  @override
  String toString() => isExact
      ? 'ExactSignedDocumentRef($id.v$version)'
      : 'LooseSignedDocumentRef($id)';
}
