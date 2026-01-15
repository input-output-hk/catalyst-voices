import 'dart:convert' show json, utf8;

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

final class SignedDocumentBinaryPayload extends SignedDocumentPayload {
  final Uint8List data;

  const SignedDocumentBinaryPayload(this.data);

  @override
  List<Object?> get props => [data];

  @override
  Uint8List toBytes() => data;
}

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

final class SignedDocumentJsonSchemaPayload extends SignedDocumentPayload {
  final Map<String, dynamic> data;

  const SignedDocumentJsonSchemaPayload(this.data);

  factory SignedDocumentJsonSchemaPayload.fromBytes(Uint8List bytes) {
    final decoded = json.fuse(utf8).decode(bytes);

    return SignedDocumentJsonSchemaPayload(decoded! as Map<String, dynamic>);
  }

  @override
  List<Object?> get props => [data];

  @override
  Uint8List toBytes() => Uint8List.fromList(json.fuse(utf8).encode(data));
}

/// Represents [SignedDocument] payload. Type of payload depends on a
/// [DocumentDataMetadata.contentType] and subclasses
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
    required DocumentContentType contentType,
  }) {
    return switch (contentType) {
      DocumentContentType.json => SignedDocumentJsonPayload.fromBytes(bytes),
      DocumentContentType.schemaJson => SignedDocumentJsonSchemaPayload.fromBytes(bytes),
      DocumentContentType.unknown => SignedDocumentUnknownPayload(bytes),
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
