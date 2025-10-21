// ignore_for_file: one_member_abstracts

import 'dart:typed_data';

import 'package:catalyst_voices_models/src/document/data/document_type.dart';
import 'package:catalyst_voices_models/src/document/document_ref.dart';
import 'package:catalyst_voices_models/src/signed_document/signed_document_payload.dart';
import 'package:catalyst_voices_models/src/user/catalyst_id.dart';
import 'package:equatable/equatable.dart';

/// Represents an abstract document that is protected
/// with cryptographic signature.
///
/// The [payload] can be UTF-8 encoded bytes, a binary data
/// or anything else that can be represented in binary format.
abstract interface class SignedDocument {
  /// The default constructor for the [SignedDocument].
  const SignedDocument();

  /// A getter returning the metadata related to the signed document.
  SignedDocumentMetadata get metadata;

  /// A getter that returns a parsed document payload.
  SignedDocumentPayload get payload;

  /// Returns a list of [CatalystId] that signed the document.
  List<CatalystId> get signers;

  /// Converts the document into binary representation.
  Uint8List toBytes();

  /// Verifies if the [payload] has been signed by a private key
  /// that belongs to the given [catalystId].
  Future<bool> verifySignature(CatalystId catalystId);
}

/// Defines the content type of the [SignedDocumentPayload].
enum SignedDocumentContentType {
  /// The document's content type is JSON.
  json,

  /// Unrecognized content type.
  unknown,
}

final class SignedDocumentMetadata extends Equatable {
  /// The document content type.
  final SignedDocumentContentType contentType;

  /// The type of document this signed document encodes.
  final DocumentType documentType;

  /// Unique identifier for the entity
  final String? id;

  /// Version ID for the Proposal.
  final String? ver;

  /// This is a reference to another document.
  ///
  /// The purpose of the ref will vary depending on the document type.
  final SignedDocumentMetadataRef? ref;

  /// If the document was formed from a template,
  /// this is a reference to that template document.
  final SignedDocumentMetadataRef? template;

  /// A reply to another document.
  final SignedDocumentMetadataRef? reply;

  /// A reference to a section of a document.
  final String? section;

  /// A list of entities other than the original author that may also
  /// publish versions of this document.
  ///
  /// This may be updated by the original author,
  /// or any collaborator that is given "author" privileges.
  final List<CatalystId>? collaborators;

  /// A list of referenced parameters, like brand, campaign or category.
  final List<SignedDocumentMetadataRef> parameters;

  const SignedDocumentMetadata({
    required this.contentType,
    required this.documentType,
    this.id,
    this.ver,
    this.ref,
    this.template,
    this.reply,
    this.section,
    this.collaborators,
    this.parameters = const [],
  });

  @override
  List<Object?> get props => [
    contentType,
    documentType,
    id,
    ver,
    ref,
    template,
    reply,
    collaborators,
    parameters,
  ];
}

/// A reference to an entity represented by the [id].
/// Optionally the version of the entity may be specified by the [ver].
final class SignedDocumentMetadataRef extends Equatable {
  /// The referenced entity uuid.
  final String id;

  /// The version of the referenced entity.
  final String ver;

  /// The default constructor for the [SignedDocumentMetadataRef].
  const SignedDocumentMetadataRef({
    required this.id,
    required this.ver,
  });

  /// Creates an instance of [SignedDocumentMetadataRef] from [DocumentRef].
  factory SignedDocumentMetadataRef.fromDocumentRef(DocumentRef ref) {
    return SignedDocumentMetadataRef(
      id: ref.id,
      ver: ref.version ?? ref.id,
    );
  }

  @override
  List<Object?> get props => [id, ver];
}
