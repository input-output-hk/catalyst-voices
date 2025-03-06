import 'dart:convert' show json, utf8;

import 'package:catalyst_voices_models/src/signed_document/signed_document.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

final class SignedDocumentJsonPayload extends Equatable
    implements SignedDocumentPayload {
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
