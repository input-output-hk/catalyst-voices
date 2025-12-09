import 'package:catalyst_cose/catalyst_cose.dart';
import 'package:cbor/cbor.dart';

/// Supported Content Media Types.
/// If the Media Type is supported by COAP, then the `uint` CoAP encoded
/// version of the media type must be used, in preference to the string.
enum CoseMediaType {
  /// application/cbor
  cbor('application/cbor', 60),

  /// application/cddl
  cddl('application/cddl'),

  /// application/json
  json('application/json', 50),

  /// application/schema+json
  schemaJson('application/schema+json'),

  /// text/css; charset=utf-8
  css('text/css; charset=utf-8', 20000),

  /// text/css; charset=utf-8; template=handlebars
  cssHandlebars('text/css; charset=utf-8; template=handlebars'),

  /// text/html; charset=utf-8
  html('text/html; charset=utf-8'),

  /// text/html; charset=utf-8; template=handlebars
  htmlHandlebars('text/html; charset=utf-8; template=handlebars'),

  /// text/markdown; charset=utf-8
  markdown('text/markdown; charset=utf-8'),

  /// text/markdown; charset=utf-8; template=handlebars
  markdownHandlebars('text/markdown; charset=utf-8; template=handlebars'),

  /// text/plain; charset=utf-8
  plain('text/plain; charset=utf-8', 0),

  /// text/plain; charset=utf-8; template=handlebars
  plainHandlebars('text/plain; charset=utf-8; template=handlebars');

  /// The media type string representation.
  final String tag;

  /// The coap encoded uint value.
  ///
  /// Preferred over [tag] if available.
  final int? coap;

  /// The default constructor for the [CoseMediaType].
  const CoseMediaType(this.tag, [this.coap]);

  /// Deserializes the type from cbor.
  factory CoseMediaType.fromCbor(CborValue value) {
    if (value is CborSmallInt) {
      for (final item in values) {
        if (item.coap == value.value) {
          return item;
        }
      }
    }

    if (value is CborString) {
      for (final item in values) {
        if (item.tag.toLowerCase() == value.toString().toLowerCase()) {
          return item;
        }
      }
    }

    throw CoseFormatException('CoseMediaType: unknown $value');
  }

  /// Serializes the type as cbor.
  CborValue toCbor() {
    final coap = this.coap;
    if (coap != null) {
      return CborSmallInt(coap);
    } else {
      return CborString(tag);
    }
  }
}
