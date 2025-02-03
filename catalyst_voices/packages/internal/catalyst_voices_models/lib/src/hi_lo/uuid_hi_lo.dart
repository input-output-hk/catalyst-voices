import 'package:catalyst_voices_models/src/hi_lo/hi_lo.dart';
import 'package:convert/convert.dart';
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
    final high = BigInt.parse(hex.encode(bytes.sublist(0, 8)), radix: 16);
    final low = BigInt.parse(hex.encode(bytes.sublist(8, 16)), radix: 16);

    return UuidHiLo(
      high: high,
      low: low,
    );
  }

  /// Version is always 13th digit of uuid.
  /// This methods assumes [source] is sanitized (no '-').
  static int _getVersion(String source) {
    return int.parse(String.fromCharCode(source.codeUnitAt(12)));
  }

  String get _fullHex => _highHex + _lowHex;

  String get _highHex => high.toRadixString(16).padLeft(16, '0');

  String get _lowHex => low.toRadixString(16).padLeft(16, '0');

  String get uuid {
    final fullHex = _fullHex;
    final bytes = UuidParsing.parseHexToBytes(fullHex);

    return UuidParsing.unparse(bytes);
  }

  /// supported for v7 only. Otherwise throws exception
  DateTime get dateTime {
    if (_getVersion(_highHex) != 7) {
      throw StateError('uuid version is not v7');
    }

    final msTimestamp = (high >> 16).toInt();

    return DateTime.fromMillisecondsSinceEpoch(msTimestamp);
  }
}
