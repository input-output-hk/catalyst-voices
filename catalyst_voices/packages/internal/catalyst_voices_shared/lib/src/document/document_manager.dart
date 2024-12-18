import 'dart:typed_data';

import 'package:catalyst_compression/catalyst_compression.dart';
import 'package:catalyst_cose/catalyst_cose.dart';
import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';

part 'document_manager_impl.dart';

/// Parses the document from the bytes obtained from [Document.toBytes].
///
/// Usually this would convert the [bytes] into a [String],
/// decode a [String] into a json and then parse the data class
/// from the json representation.
typedef DocumentParser<T extends Document> = T Function(Uint8List bytes);

/// Manages the [SignedDocument]s.
abstract interface class DocumentManager {
  /// The default constructor for the [DocumentManager],
  /// provides the default implementation of the interface.
  const factory DocumentManager() = _DocumentManagerImpl;

  /// Parses the document from the [bytes] representation.
  ///
  /// The [parser] must be able to parse the document
  /// from the bytes produced by [Document.toBytes].
  ///
  /// The implementation of this method must be able to understand the [bytes]
  /// that are obtained from the [SignedDocument.toBytes] method.
  Future<SignedDocument<T>> parseDocument<T extends Document>(
    Uint8List bytes, {
    required DocumentParser<T> parser,
  });

  /// Signs the [document] with a single [privateKey].
  ///
  /// The [publicKey] will be added as metadata in the signed document
  /// so that it's easier to identify who signed it.
  Future<SignedDocument<T>> signDocument<T extends Document>(
    T document, {
    required Uint8List publicKey,
    required Uint8List privateKey,
  });
}

/// Represents an abstract document that is protected
/// with cryptographic signature.
///
/// The [document] payload can be UTF-8 encoded bytes, a binary data
/// or anything else that can be represented in binary format.
abstract base class SignedDocument<T extends Document> extends Equatable {
  /// The default constructor for the [SignedDocument].
  const SignedDocument();

  /// A getter that returns a parsed document.
  T get document;

  /// Verifies if the [document] has been signed by a private key
  /// that belongs to the given [publicKey].
  Future<bool> verifySignature(Uint8List publicKey);

  /// Converts the document into binary representation.
  Uint8List toBytes();
}

/// Represents an abstract document that can be represented in binary format.
// ignore: one_member_abstracts
abstract interface class Document {
  /// Converts the document into a binary representation.
  ///
  /// See [DocumentParser].
  Uint8List toBytes();

  /// Returns the document content type.
  DocumentContentType get contentType;
}

/// Defines the content type of the [Document].
enum DocumentContentType {
  /// The document's content type is JSON.
  json,
}
