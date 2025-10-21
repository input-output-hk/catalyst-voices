import 'dart:convert';
import 'dart:typed_data';

import 'package:cbor/cbor.dart';
import 'package:equatable/equatable.dart';

/// RFC6901 Standard JSON Pointer
class JsonPointer extends Equatable {
  /// The string [text] of the pointer.
  final String text;

  /// The default constructor for the [JsonPointer].
  const JsonPointer(this.text);

  /// Deserializes the type from cbor.
  JsonPointer.fromCbor(CborValue value) : this(((value as CborString).toString()));

  @override
  List<Object?> get props => [text];

  /// Serializes the type as cbor.
  CborValue toCbor() {
    return CborString(text);
  }
}

/// Reference to a section in a referenced document.
class SectionRef extends JsonPointer {
  /// The default constructor for the [SectionRef].
  const SectionRef(super.text);

  /// Deserializes the type from cbor.
  SectionRef.fromCbor(super.value) : super.fromCbor();
}

/// UTF-8 Catalyst ID URI encoded as a bytes string.
extension type const CatalystIdKid(Uint8List bytes) {
  /// Deserializes the type from cbor.
  factory CatalystIdKid.fromCbor(CborValue value) {
    return CatalystIdKid(Uint8List.fromList((value as CborBytes).bytes));
  }

  /// Creates a new [CatalystIdKid] from [string].
  factory CatalystIdKid.fromString(String string) {
    return CatalystIdKid(utf8.encode(string));
  }

  /// Serializes the type as cbor.
  CborValue toCbor() {
    return CborBytes(bytes);
  }
}
