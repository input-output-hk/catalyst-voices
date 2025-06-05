import 'package:uuid_plus/uuid_plus.dart';

abstract final class UuidUtils {
  UuidUtils._();

  static String buildV7At(DateTime dateTime) {
    final config = V7Options(dateTime.millisecondsSinceEpoch, null);
    return const Uuid().v7(config: config);
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
