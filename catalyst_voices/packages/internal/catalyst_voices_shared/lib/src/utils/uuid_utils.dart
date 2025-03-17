import 'package:uuid_plus/uuid_plus.dart';

abstract final class UuidUtils {
  UuidUtils._();

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
