import 'package:catalyst_voices_models/src/hi_lo/hi_lo.dart';
import 'package:convert/convert.dart';
import 'package:uuid/parsing.dart';
import 'package:uuid/validation.dart';

final class UuidHiLo extends HiLo<BigInt> {
  const UuidHiLo({
    required super.high,
    required super.low,
  });

  factory UuidHiLo.fromV7(String data) {
    data = data.replaceAll('-', '');
    if (!UuidValidation.isValidUUID(fromString: data, noDashes: true)) {
      throw ArgumentError('Not valid uuid data', 'data');
    }

    /// Version is always 13th digit
    if (int.parse(String.fromCharCode(data.codeUnitAt(12))) != 7) {
      throw ArgumentError('Provided uuid is not v7', 'data');
    }

    final bytes = UuidParsing.parseHexToBytes(data);

    // Split into two 64-bit integers
    final high = BigInt.parse(hex.encode(bytes.sublist(0, 8)), radix: 16);
    final low = BigInt.parse(hex.encode(bytes.sublist(8, 16)), radix: 16);

    return UuidHiLo(
      high: high,
      low: low,
    );
  }

  String get uuid {
    final highHex = high.toRadixString(16).padLeft(16, '0');
    final lowHex = low.toRadixString(16).padLeft(16, '0');

    final fullHex = highHex + lowHex;
    final bytes = UuidParsing.parseHexToBytes(fullHex);

    return UuidParsing.unparse(bytes);
  }
}
