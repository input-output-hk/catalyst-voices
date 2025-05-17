import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

base class MaybeTypedDocumentRef extends Equatable {
  final DocumentRef ref;
  final DocumentType? type;

  const MaybeTypedDocumentRef({
    required this.ref,
    this.type,
  });

  @override
  List<Object?> get props => [ref, type];

  MaybeTypedDocumentRef copyWith({
    DocumentRef? ref,
    DocumentType? type,
  }) {
    return MaybeTypedDocumentRef(
      ref: ref ?? this.ref,
      type: type ?? this.type,
    );
  }

  MaybeTypedDocumentRef copyWithVersion(String version) {
    return copyWith(ref: ref.copyWith(version: Optional(version)));
  }
}

final class TypedDocumentRef extends MaybeTypedDocumentRef {
  const TypedDocumentRef({
    required super.ref,
    required DocumentType super.type,
  });

  @override
  List<Object?> get props => [ref, type];

  @override
  DocumentType get type => super.type!;

  @override
  TypedDocumentRef copyWith({
    DocumentRef? ref,
    DocumentType? type,
  }) {
    return TypedDocumentRef(
      ref: ref ?? this.ref,
      type: type ?? this.type,
    );
  }

  @override
  TypedDocumentRef copyWithVersion(String version) {
    return copyWith(ref: ref.copyWith(version: Optional(version)));
  }
}
