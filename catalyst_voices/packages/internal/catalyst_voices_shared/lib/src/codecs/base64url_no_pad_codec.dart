import 'dart:convert';
import 'dart:typed_data';

/// Encodes/decodes base64Url with no padding.
const Base64UrlNoPadCodec base64UrlNoPad = Base64UrlNoPadCodec();

/// The padding character to fill the base64Url string
/// until the string length is a multiple of 4.
const String _paddingChar = '=';

/// Decodes a base64Url [input] with no padding.
Uint8List base64UrlNoPadDecode(String input) => base64UrlNoPad.decode(input);

/// Encodes a base64Url string from [bytes] with no padding.
String base64UrlNoPadEncode(Uint8List bytes) => base64UrlNoPad.encode(bytes);

/// A [Codec] which can encode/decode a base64Url with no padding.
///
/// The default dart implementation of [base64Decode] requires the padding
/// therefore we are adding it manually if it's missing so that the method
/// can parse it.
class Base64UrlNoPadCodec extends Codec<Uint8List, String> {
  const Base64UrlNoPadCodec();

  @override
  Converter<String, Uint8List> get decoder => const Base64UrlNoPadDecoder();

  @override
  Converter<Uint8List, String> get encoder => const Base64UrlNoPadEncoder();
}

class Base64UrlNoPadDecoder extends Converter<String, Uint8List> {
  const Base64UrlNoPadDecoder();

  @override
  Uint8List convert(String input) {
    final fixedInput = _addPadding(input);
    return base64Decode(fixedInput);
  }

  /// base64 string length needs to be multiple of 4,
  /// we're adding missing padding until the length is valid.
  String _addPadding(String input) {
    final buffer = StringBuffer(input);
    while (buffer.length % 4 != 0) {
      buffer.write(_paddingChar);
    }
    return buffer.toString();
  }
}

class Base64UrlNoPadEncoder extends Converter<Uint8List, String> {
  const Base64UrlNoPadEncoder();

  @override
  String convert(Uint8List input) {
    final encoded = base64UrlEncode(input);
    return _removePadding(encoded);
  }

  /// Strips the [input] from padding.
  String _removePadding(String input) {
    return input.replaceAll(_paddingChar, '');
  }
}
