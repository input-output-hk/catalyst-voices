import 'dart:convert' show json, utf8;

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

final class SignedDocumentJsonPayload extends SignedDocumentPayload {
  final Map<String, dynamic> data;

  const SignedDocumentJsonPayload(this.data);

  factory SignedDocumentJsonPayload.fromBytes(Uint8List bytes) {
    final decoded = json.fuse(utf8).decode(bytes);

    return SignedDocumentJsonPayload(decoded! as Map<String, dynamic>);
  }

  @override
  List<Object?> get props => [data];

  @override
  Uint8List toBytes() => Uint8List.fromList(json.fuse(utf8).encode(data));
}

/// Represents [SignedDocument] payload. Type of payload depends on a
/// [SignedDocumentMetadata.contentType] and subclasses
/// of [SignedDocumentPayload] are meant to reflect that.
///
/// Use [SignedDocumentPayload.fromBytes] factory to create correct
/// payload type.
sealed class SignedDocumentPayload extends Equatable {
  const SignedDocumentPayload();

  /// Creates corresponding payload base on [contentType].
  /// In case of unknown type falling back to [SignedDocumentUnknownPayload]
  /// which keeps [bytes] as is.
  factory SignedDocumentPayload.fromBytes(
    Uint8List bytes, {
    required SignedDocumentContentType contentType,
  }) {
    return switch (contentType) {
      SignedDocumentContentType.json =>
        SignedDocumentJsonPayload.fromBytes(bytes),
      SignedDocumentContentType.unknown => SignedDocumentUnknownPayload(bytes)
    };
  }

  /// Converts the document into a binary representation.
  Uint8List toBytes();
}

final class SignedDocumentUnknownPayload extends SignedDocumentPayload {
  final Uint8List data;

  const SignedDocumentUnknownPayload(this.data);

  @override
  List<Object?> get props => [data];

  @override
  Uint8List toBytes() => data;
}
