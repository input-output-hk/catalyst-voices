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

/// Represents an abstract document that can be represented in binary format.
sealed class SignedDocumentPayload extends Equatable {
  const SignedDocumentPayload();

  /// Parses the document from the bytes obtained
  /// from [SignedDocumentPayload.toBytes].
  ///
  /// Usually this would convert the [bytes] into a [String],
  /// decode a [String] into a json and then parse the data class
  /// from the json representation.
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
