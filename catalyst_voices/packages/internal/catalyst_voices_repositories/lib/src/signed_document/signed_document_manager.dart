import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/signed_document/signed_document_manager_impl.dart';
import 'package:flutter/foundation.dart';

/// Parses the document from the bytes obtained
/// from [SignedDocumentPayload.toBytes].
///
/// Usually this would convert the [bytes] into a [String],
/// decode a [String] into a json and then parse the data class
/// from the json representation.
typedef SignedDocumentPayloadParser<T extends SignedDocumentPayload> = T
    Function(Uint8List bytes);

/// Manages the [SignedDocument]s.
abstract interface class SignedDocumentManager {
  /// The default constructor for the [SignedDocumentManager],
  /// provides the default implementation of the interface.
  const factory SignedDocumentManager() = SignedDocumentManagerImpl;

  /// Parses the document from the [bytes] representation.
  ///
  /// The [parser] must be able to parse the document
  /// from the bytes produced by [SignedDocumentPayload.toBytes].
  ///
  /// The implementation of this method must be able to understand the [bytes]
  /// that are obtained from the [SignedDocument.toBytes] method.
  Future<SignedDocument<T>> parseDocument<T extends SignedDocumentPayload>(
    Uint8List bytes, {
    required SignedDocumentPayloadParser<T> parser,
  });

  /// Signs the [document] with a single [privateKey].
  ///
  /// The [publicKey] will be added as metadata in the signed document
  /// so that it's easier to identify who signed it.
  Future<SignedDocument<T>> signDocument<T extends SignedDocumentPayload>(
    T document, {
    required SignedDocumentMetadata metadata,
    required CatalystPublicKey publicKey,
    required CatalystPrivateKey privateKey,
  });
}
