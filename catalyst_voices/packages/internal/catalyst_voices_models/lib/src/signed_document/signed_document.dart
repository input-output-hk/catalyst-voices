// ignore_for_file: one_member_abstracts

import 'dart:typed_data';

import 'package:equatable/equatable.dart';

/// Represents an abstract document that is protected
/// with cryptographic signature.
///
/// The [payload] can be UTF-8 encoded bytes, a binary data
/// or anything else that can be represented in binary format.
abstract interface class SignedDocument<T extends SignedDocumentPayload> {
  /// The default constructor for the [SignedDocument].
  const SignedDocument();

  /// A getter that returns a parsed document payload.
  T get payload;

  /// Converts the document into binary representation.
  Uint8List toBytes();

  /// Verifies if the [payload] has been signed by a private key
  /// that belongs to the given [publicKey].
  Future<bool> verifySignature(Uint8List publicKey);
}

/// Defines the content type of the [SignedDocumentPayload].
enum SignedDocumentContentType {
  /// The document's content type is JSON.
  json,
}

final class SignedDocumentMetadata extends Equatable {
  /// Returns the document content type.
  final SignedDocumentContentType contentType;

  const SignedDocumentMetadata({
    required this.contentType,
  });

  @override
  List<Object?> get props => [contentType];
}

/// Represents an abstract document that can be represented in binary format.
abstract interface class SignedDocumentPayload {
  /// Converts the document into a binary representation.
  Uint8List toBytes();
}
