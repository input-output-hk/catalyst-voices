import 'package:uuid_plus/uuid_plus.dart';

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
    var timestampMillis = BigInt.from(0);
    for (var i = 0; i < 6; i++) {
      // Using BigInt due to how JS binary shift works,
      // it truncates the number to be uint32 which is not enough in this case.
      timestampMillis = (timestampMillis << 8) | BigInt.from(bytes[i]);
    }

    return DateTime.fromMillisecondsSinceEpoch(
      timestampMillis.toInt(),
      isUtc: true,
    );
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
