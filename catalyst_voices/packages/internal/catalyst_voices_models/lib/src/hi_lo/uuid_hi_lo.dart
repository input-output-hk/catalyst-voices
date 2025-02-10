import 'package:catalyst_voices_models/src/hi_lo/hi_lo.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/parsing.dart';
import 'package:uuid/validation.dart';

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

    final bytes = UuidParsing.parseHexToBytes(sanitized);
    final high = BigInt.from(ByteData.sublistView(bytes, 0, 8).getInt64(0));
    final low = BigInt.from(ByteData.sublistView(bytes, 8, 16).getInt64(0));

    return UuidHiLo(
      high: high,
      low: low,
    );
  }

  /// Version is always 13th digit of uuid.
  int get _version {
    final source = String.fromCharCode(uuid.codeUnitAt(14));
    return int.parse(source);
  }

  String get uuid {
    // Convert BigInt back to bytes
    final highBytes = ByteData(8)..setInt64(0, high.toInt());
    final lowBytes = ByteData(8)..setInt64(0, low.toInt());

    // Merge them into a single byte array
    final bytes = Uint8List.fromList([
      ...highBytes.buffer.asUint8List(),
      ...lowBytes.buffer.asUint8List(),
    ]);

    return UuidParsing.unparse(bytes);
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
}
