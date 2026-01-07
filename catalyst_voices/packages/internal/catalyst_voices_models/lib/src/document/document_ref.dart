import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid_plus/uuid_plus.dart';

/// Represents ref to any kind of document. Documents often have refs to other document
/// and this class is representation of that.
///
/// [id] and [version] are usually a UUID, often UUIDv7.
///
/// Implements [Comparable] and tries to sort base on [version] date time extracted from UUIDv7
/// timestamp.
///
/// Ref can be **exact** or **loose**:
/// - when [version] is non null it is exact because it points to single document.
/// - when [version] is null it is loose because it points to newest version of document.
///
/// Types:
/// - [SignedDocumentRef] it points to signed, published document.
/// - [DraftRef] it points to local version, sometimes called localDraft, of document. It can
/// be malformed and incomplete.
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

  bool get isGenesis => id == version;

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

  /// Generates a new (fresh) draft version of the document reference.
  ///
  /// If the [id] == [version] then a new [id] will be generated since it's considered the
  /// first version of the document. The [version] will be the same as [id].
  ///
  /// If [id] != [version] then only a new version is generated equalling to [DateTime.now].
  DraftRef fresh() {
    if (isGenesis) {
      return DraftRef.generateFirstRef();
    }

    return DraftRef(
      id: id,
      version: const Uuid().v7(),
    );
  }

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

  /// Converts to [TypedDocumentRef] with given [type].
  TypedDocumentRef toTyped(DocumentType type) {
    return TypedDocumentRef(ref: this, type: type);
  }
}

/// Ref to local draft document.
final class DraftRef extends DocumentRef {
  const DraftRef({
    required super.id,
    super.version,
  });

  /// Creates ref for first [version] of [id] draft.
  const DraftRef.first(String id) : this(id: id, version: id);

  /// Shortcut for [DraftRef.first].
  factory DraftRef.generateFirstRef() {
    final id = const Uuid().v7();
    return DraftRef.first(id);
  }

  factory DraftRef.generateNextRefFor(String id) {
    return DraftRef(
      id: id,
      version: const Uuid().v7(),
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
  String toString() => isExact ? 'ExactDraftRef($id.v$version)' : 'LooseDraftRef($id)';
}

/// Ref to published document.
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

  /// Shortcut for [SignedDocumentRef.first].
  factory SignedDocumentRef.generateFirstRef() {
    final id = const Uuid().v7();
    return SignedDocumentRef.first(id);
  }

  const SignedDocumentRef.loose({required super.id});

  bool get isValid {
    final isIdValid = Uuid.isValidUUID(fromString: id);
    final isVersionValid = version == null || Uuid.isValidUUID(fromString: version!);

    return isIdValid && isVersionValid;
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
  SignedDocumentRef toLoose() => copyWith(version: const Optional.empty());

  @override
  SignedDocumentRef toSignedDocumentRef() => this;

  @override
  String toString() =>
      isExact ? 'ExactSignedDocumentRef($id.v$version)' : 'LooseSignedDocumentRef($id)';
}

final class TypedDocumentRef extends Equatable {
  final DocumentRef ref;
  final DocumentType type;

  const TypedDocumentRef({
    required this.ref,
    required this.type,
  });

  @override
  List<Object?> get props => [ref, type];

  TypedDocumentRef copyWith({
    DocumentRef? ref,
    DocumentType? type,
  }) {
    return TypedDocumentRef(
      ref: ref ?? this.ref,
      type: type ?? this.type,
    );
  }

  TypedDocumentRef copyWithVersion(String version) {
    return copyWith(ref: ref.copyWith(version: Optional(version)));
  }
}
