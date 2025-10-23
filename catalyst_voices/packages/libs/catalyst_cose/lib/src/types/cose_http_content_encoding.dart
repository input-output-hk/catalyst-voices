import 'package:catalyst_cose/src/exception/cose_format_exception.dart';
import 'package:cbor/cbor.dart';

/// Supported Content Encoding Types
enum CoseHttpContentEncoding {
  /// brotli content encoding.
  brotli('br');

  /// The content encoding string representation.
  final String tag;

  /// The default constructor for the [CoseHttpContentEncoding].
  const CoseHttpContentEncoding(this.tag);

  /// Deserializes the type from cbor.
  factory CoseHttpContentEncoding.fromCbor(CborValue value) {
    final string = value as CborString;
    for (final item in values) {
      if (item.tag.toLowerCase() == string.toString().toLowerCase()) {
        return item;
      }
    }

    throw CoseFormatException('CoseHttpContentEncoding: unknown $value');
  }

  /// Serializes the type as cbor.
  CborValue toCbor() => CborString(tag);
}
