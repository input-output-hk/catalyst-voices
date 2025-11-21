// ignore_for_file: one_member_abstracts

import 'dart:typed_data';

import 'package:catalyst_voices_models/src/document/data/document_data_metadata.dart';
import 'package:catalyst_voices_models/src/signed_document/signed_document_payload.dart';
import 'package:catalyst_voices_models/src/user/catalyst_id.dart';

/// Represents an abstract document that is protected
/// with cryptographic signature.
///
/// The [payload] can be UTF-8 encoded bytes, a binary data
/// or anything else that can be represented in binary format.
abstract interface class SignedDocument {
  /// The default constructor for the [SignedDocument].
  const SignedDocument();

  /// A getter returning the metadata related to the signed document.
  DocumentDataMetadata get metadata;

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
