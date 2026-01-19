import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';
import 'package:uuid_plus/uuid_plus.dart';

/// Represents ref to any kind of document. Documents often have refs to other document
/// and this class is representation of that.
///
/// [id] and [ver] are usually a UUID, often UUIDv7.
///
/// Implements [Comparable] and tries to sort base on [ver] date time extracted from UUIDv7
/// timestamp.
///
/// Ref can be **exact** or **loose**:
/// - when [ver] is non null it is exact because it points to single document.
/// - when [ver] is null it is loose because it points to newest version of document.
///
/// Types:
/// - [SignedDocumentRef] it points to signed, published document.
/// - [DraftRef] it points to local version, sometimes called localDraft, of document. It can
/// be malformed and incomplete.
sealed class DocumentRef extends Equatable implements Comparable<DocumentRef> {
  final String id;
  final String? ver;

  const DocumentRef({
    required this.id,
    this.ver,
  });

  factory DocumentRef.build({
    required String id,
    String? ver,
    required bool isDraft,
  }) {
    return isDraft ? DraftRef(id: id, ver: ver) : SignedDocumentRef(id: id, ver: ver);
  }

  bool get isDraft => this is DraftRef;

  /// Whether the ref specifies the document [ver].
  bool get isExact => ver != null;

  bool get isLoose => !isExact;

  bool get isSigned => this is SignedDocumentRef;

  bool get isGenesis => id == ver;

  @override
  List<Object?> get props => [id, ver];

  @override
  int compareTo(DocumentRef other) {
    final dateTime = ver?.tryDateTime;
    final otherDateTime = other.ver?.tryDateTime;

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
    Optional<String>? ver,
  });

  /// Generates a new (fresh) draft version of the document reference.
  ///
  /// If the [id] == [ver] then a new [id] will be generated since it's considered the
  /// first version of the document. The [ver] will be the same as [id].
  ///
  /// If [id] != [ver] then only a new version is generated equalling to [DateTime.now].
  DraftRef fresh() {
    if (isGenesis) {
      return DraftRef.generateFirstRef();
    }

    return DraftRef(
      id: id,
      ver: const Uuid().v7(),
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
}

/// Ref to local draft document.
final class DraftRef extends DocumentRef {
  const DraftRef({
    required super.id,
    super.ver,
  });

  /// Creates ref for first [ver] of [id] draft.
  const DraftRef.first(String id) : this(id: id, ver: id);

  /// Shortcut for [DraftRef.first].
  factory DraftRef.generateFirstRef() {
    final id = const Uuid().v7();
    return DraftRef.first(id);
  }

  factory DraftRef.generateNextRefFor(String id) {
    return DraftRef(
      id: id,
      ver: const Uuid().v7(),
    );
  }

  @override
  DraftRef copyWith({
    String? id,
    Optional<String>? ver,
  }) {
    return DraftRef(
      id: id ?? this.id,
      ver: ver.dataOr(this.ver),
    );
  }

  @override
  DraftRef nextVersion() => this;

  @override
  DraftRef toLoose() => copyWith(ver: const Optional.empty());

  @override
  SignedDocumentRef toSignedDocumentRef() => SignedDocumentRef(
    id: id,
    ver: ver,
  );

  @override
  String toString() => isExact ? 'ExactDraftRef($id.v$ver)' : 'LooseDraftRef($id)';
}

/// Ref to published document.
final class SignedDocumentRef extends DocumentRef {
  const SignedDocumentRef({
    required super.id,
    super.ver,
  });

  const SignedDocumentRef.exact({
    required super.id,
    required String super.ver,
  });

  /// Creates ref for first version of [id] document.
  const SignedDocumentRef.first(String id) : this(id: id, ver: id);

  /// Shortcut for [SignedDocumentRef.first].
  factory SignedDocumentRef.generateFirstRef() {
    final id = const Uuid().v7();
    return SignedDocumentRef.first(id);
  }

  const SignedDocumentRef.loose({required super.id});

  bool get isValid {
    final isIdValid = Uuid.isValidUUID(fromString: id);
    final isVersionValid = ver == null || Uuid.isValidUUID(fromString: ver!);

    return isIdValid && isVersionValid;
  }

  @override
  SignedDocumentRef copyWith({
    String? id,
    Optional<String>? ver,
  }) {
    return SignedDocumentRef(
      id: id ?? this.id,
      ver: ver.dataOr(this.ver),
    );
  }

  @override
  DraftRef nextVersion() {
    return DraftRef(
      id: id,
      ver: const Uuid().v7(),
    );
  }

  @override
  SignedDocumentRef toLoose() => copyWith(ver: const Optional.empty());

  @override
  SignedDocumentRef toSignedDocumentRef() => this;

  @override
  String toString() =>
      isExact ? 'ExactSignedDocumentRef($id.v$ver)' : 'LooseSignedDocumentRef($id)';
}
