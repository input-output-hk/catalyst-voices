import 'package:catalyst_voices_models/src/hi_lo/hi_lo.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/parsing.dart';
import 'package:uuid/validation.dart';

// Ensure values are within the signed 64-bit range
// ignore: unused_element
final _min64 = BigInt.parse('-9223372036854775808');
final _max64 = BigInt.parse('9223372036854775807');
// 2^64 - 1 (Unsigned 64-bit max)
final _mask = BigInt.parse('18446744073709551615');

/// High and Low representation of uuid as num.
final class UuidHiLo extends HiLo<BigInt> {
  const UuidHiLo({
    required super.high,
    required super.low,
  });

  /// UUIDv7 is structured as follows:
  ///
  /// - First 48 bits (Timestamp): Milliseconds since Unix epoch.
  /// - Next 16 bits (Version and Variant): Metadata indicating UUID version
  ///   and variant.
  /// - Last 64 bits (Random/Entropy): Randomly generated for uniqueness.
  factory UuidHiLo.from(String data) {
    final sanitized = data.replaceAll('-', '');
    if (!UuidValidation.isValidUUID(fromString: sanitized, noDashes: true)) {
      throw ArgumentError('Not valid uuid data', 'data');
    }

    /// The reason is that dart2js does not fully support Int64 operations
    /// and getInt64() throws exception on web.
    final bytes = UuidParsing.parseHexToBytes(sanitized);

    var high = BigInt.zero;
    for (var i = 0; i < 8; i++) {
      high = (high << 8) | BigInt.from(bytes[i]);
    }

    var low = BigInt.zero;
    for (var i = 8; i < 16; i++) {
      low = (low << 8) | BigInt.from(bytes[i]);
    }

    high = high & _mask; // Apply mask to limit to 64-bit
    low = low & _mask;

    // Convert to signed 64-bit range if necessary
    if (high > _max64) high -= (_mask + BigInt.one);
    if (low > _max64) low -= (_mask + BigInt.one);

    return UuidHiLo(
      high: high,
      low: low,
    );
  }

  /// supported for v7 only. Otherwise throws exception
  DateTime get dateTime {
    if (_version != 7) {
      throw StateError('uuid version is not v7');
    }

    // Get the first 48 bits (high >> 16)
    final timestampMillis = (high.toInt() >> 16) & 0xFFFFFFFFFFFF;

    // Convert milliseconds since Unix epoch (1970-01-01)
    return DateTime.fromMillisecondsSinceEpoch(timestampMillis);
  }

  String get uuid {
    // Convert `high` and `low` into 8-byte arrays manually
    final highBytes = Uint8List(8);
    final lowBytes = Uint8List(8);

    var tempHigh = high;
    var tempLow = low;

    for (var i = 7; i >= 0; i--) {
      highBytes[i] = (tempHigh & BigInt.from(0xFF)).toInt();
      tempHigh >>= 8;

      lowBytes[i] = (tempLow & BigInt.from(0xFF)).toInt();
      tempLow >>= 8;
    }

    // Combine both byte arrays
    final bytes = Uint8List.fromList([...highBytes, ...lowBytes]);

    return UuidParsing.unparse(bytes);
  }

  /// Version is always 13th digit of uuid.
  int get _version {
    final hexChar = uuid.replaceAll('-', '')[12]; // 13th hex digit
    return int.parse(hexChar, radix: 16);
  }

  /// Syntax sugar for working with nullable [data].
  static UuidHiLo? fromNullable(String? data) {
    return data != null ? UuidHiLo.from(data) : null;
  }
}
