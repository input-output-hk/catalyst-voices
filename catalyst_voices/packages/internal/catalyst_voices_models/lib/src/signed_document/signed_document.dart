import 'package:catalyst_voices_models/catalyst_voices_models.dart';

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
  DocumentArtifact toArtifact();

  /// Verifies if the [payload] has been signed by a private key
  /// that belongs to the given [catalystId].
  Future<bool> verifySignature(CatalystId catalystId);
}
