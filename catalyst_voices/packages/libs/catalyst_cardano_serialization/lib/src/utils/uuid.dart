import 'dart:typed_data';

import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';

/// The Uuid version 4 identifier.
extension type UuidV4._(List<int> bytes) {
  /// Separates groups of values in Uuid.
  static const String separator = '-';

  /// The length of the [UuidV4] in bytes.
  static const int length = 16;

  /// The default constructor for [UuidV4].
  UuidV4.fromBytes(this.bytes) {
    if (bytes.length != length) {
      throw ArgumentError(
        'UuidV4 length does not match: ${bytes.length}',
      );
    }
  }

  /// Builds a [UuidV4] from a [string].
  UuidV4.fromString(String string) : this.fromBytes(_uuidToBinary(string));

  /// Deserializes the type from cbor.
  factory UuidV4.fromCbor(CborValue value) {
    return UuidV4.fromBytes((value as CborBytes).bytes);
  }

  /// Serializes the type as cbor.
  CborValue toCbor() => CborBytes(bytes);

  /// Returns a Uuid.v4 string representation.
  String toUuidString() {
    // Insert dashes to format as UUID v4
    final hexString = hex.encode(bytes);
    final formattedUuid = '${hexString.substring(0, 8)}$separator'
        '${hexString.substring(8, 12)}$separator'
        '${hexString.substring(12, 16)}$separator'
        '${hexString.substring(16, 20)}$separator'
        '${hexString.substring(20, 32)}';

    return formattedUuid;
  }

  static Uint8List _uuidToBinary(String uuid) {
    // Remove dashes from the UUID string
    final cleanUuid = uuid.replaceAll(separator, '');

    // Convert the cleaned UUID string to a list of bytes
    final byteList = <int>[];

    for (var i = 0; i < cleanUuid.length; i += 2) {
      final byteStr = cleanUuid.substring(i, i + 2);
      final byteVal = int.parse(byteStr, radix: 16);
      byteList.add(byteVal);
    }

    return Uint8List.fromList(byteList);
  }
}

/// Utils around UUID v7.
abstract class UuidV7 {
  /// Extracts the timestamp from the Uuid V7 string.
  static DateTime parseTimestamp(String uuid) {
    final uuidParts = uuid.split('-');
    // First 48 bits of UUIDv7
    final uuidTimestampHex = uuidParts[0] + uuidParts[1].substring(0, 4);

    // Convert timestampHex to milliseconds since Unix epoch
    final timestamp = int.parse(uuidTimestampHex, radix: 16);
    return DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: true);
  }
}
