import 'package:catalyst_cose/src/utils/cbor_utils.dart';
import 'package:cbor/cbor.dart';
import 'package:uuid_plus/uuid_plus.dart' as uuid;

/// Represents the Uuid type.
///
/// Uuid v7 is preferred. The cbor representation
/// is tagged with a tag that defines the uuid type.
extension type const CoseUuid(String value) {
  /// Deserializes the type from cbor.
  factory CoseUuid.fromCbor(CborValue value) {
    if (value is CborBytes) {
      return CoseUuid(uuid.Uuid.unparse(value.bytes));
    } else {
      throw FormatException('The $value is not a valid uuid!');
    }
  }

  /// Serializes the type as cbor.
  CborValue toCbor() {
    final uuidBytes = uuid.Uuid.parse(value);
    return CborBytes(uuidBytes, tags: [CborUtils.uuidTag]);
  }
}
