import 'package:uuid/parsing.dart';
import 'package:uuid/uuid.dart';

abstract final class UuidUtils {
  UuidUtils._();

  static DateTime dateTime(
    String uuid, {
    bool noDashes = false,
  }) {
    final bytes = UuidParsing.parse(uuid, noDashes: noDashes);
    final value = UuidValue.fromList(bytes);
    if (!value.isV7) {
      throw ArgumentError('DateTime supported only for uuid v7');
    }

    // Extract the 48-bit timestamp from the first 6 bytes.
    var timestampMillis = 0;
    for (var i = 0; i < 6; i++) {
      timestampMillis = (timestampMillis << 8) | bytes[i];
    }

    return DateTime.fromMillisecondsSinceEpoch(timestampMillis, isUtc: true);
  }

  static int version(
    String uuid, {
    bool noDashes = false,
  }) {
    return UuidValue.withValidation(
      uuid,
      ValidationMode.strictRFC4122,
      noDashes,
    ).version;
  }
}
