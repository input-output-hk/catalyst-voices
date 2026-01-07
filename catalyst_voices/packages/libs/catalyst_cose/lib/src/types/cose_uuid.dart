import 'dart:typed_data';

import 'package:catalyst_cose/src/exception/cose_format_exception.dart';
import 'package:catalyst_cose/src/utils/cbor_utils.dart';
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';
import 'package:uuid_plus/uuid_plus.dart' as uuid;

/// Represents the Uuid V4 type.
///
/// The cbor representation is tagged with a tag that defines the uuid type.
extension type const CoseUuidV4._(Uint8List bytes) {
  /// Expected length when the uuid is encoded a byte list.
  static const int bytesLength = 16;

  /// Creates [CoseUuidV4] from [bytes].
  factory CoseUuidV4.fromBytes(Uint8List bytes) {
    if (bytes.length != bytesLength) {
      throw CoseFormatException('CoseUuidV4: unexpected bytes: ${hex.encode(bytes)}');
    } else {
      return CoseUuidV4._(bytes);
    }
  }

  /// Deserializes the type from cbor.
  factory CoseUuidV4.fromCbor(CborValue value) {
    if (value is CborBytes) {
      return CoseUuidV4.fromBytes(Uint8List.fromList(value.bytes));
    } else {
      throw CoseFormatException('The $value is not a valid uuid!');
    }
  }

  /// Creates [CoseUuidV4] from a [string].
  factory CoseUuidV4.fromString(String string) {
    final uuidBytes = uuid.Uuid.parse(string);
    return CoseUuidV4.fromBytes(Uint8List.fromList(uuidBytes));
  }

  /// Converts the [bytes] into uuid formatted string.
  String format() {
    return uuid.Uuid.unparse(bytes);
  }

  /// Serializes the type as cbor.
  CborValue toCbor() {
    return CborBytes(bytes, tags: [CborUtils.uuidTag]);
  }
}

/// Represents the Uuid V7 type.
///
/// The cbor representation is tagged with a tag that defines the uuid type.
extension type const CoseUuidV7._(Uint8List bytes) {
  /// Expected length when the uuid is encoded a byte list.
  static const int bytesLength = 16;

  /// Creates [CoseUuidV7] from [bytes].
  factory CoseUuidV7.fromBytes(Uint8List bytes) {
    if (bytes.length != bytesLength) {
      throw CoseFormatException('CoseUuidV7: unexpected bytes: ${hex.encode(bytes)}');
    } else {
      return CoseUuidV7._(bytes);
    }
  }

  /// Deserializes the type from cbor.
  factory CoseUuidV7.fromCbor(CborValue value) {
    if (value is CborBytes) {
      return CoseUuidV7.fromBytes(Uint8List.fromList(value.bytes));
    } else {
      throw CoseFormatException('The $value is not a valid uuid!');
    }
  }

  /// Creates [CoseUuidV7] from a [string].
  factory CoseUuidV7.fromString(String string) {
    final uuidBytes = uuid.Uuid.parse(string);
    return CoseUuidV7.fromBytes(Uint8List.fromList(uuidBytes));
  }

  /// Converts the [bytes] into uuid formatted string.
  String format() {
    return uuid.Uuid.unparse(bytes);
  }

  /// Serializes the type as cbor.
  CborValue toCbor() {
    return CborBytes(bytes, tags: [CborUtils.uuidTag]);
  }
}
