import 'dart:typed_data';

import 'package:catalyst_voices_shared/src/codecs/base64url_no_pad_codec.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(Base64UrlNoPadCodec, () {
    test('Encoding and Decoding should be consistent', () {
      final data = Uint8List.fromList([104, 101, 108, 108, 111]); // 'hello'
      final encoded = base64UrlNoPadEncode(data);
      final decoded = base64UrlNoPadDecode(encoded);
      expect(decoded, data);
    });

    test('Encoding should remove padding', () {
      final data = Uint8List.fromList([104, 101, 108, 108, 111]); // 'hello'
      final encoded = base64UrlNoPadEncode(data);
      expect(encoded.contains('='), false);
    });

    test('Decoding should handle missing padding', () {
      const encoded = 'aGVsbG8'; // 'hello' in base64Url without padding
      final decoded = base64UrlNoPadDecode(encoded);
      expect(decoded, Uint8List.fromList([104, 101, 108, 108, 111])); // 'hello'
    });

    test('Encoding and decoding binary data', () {
      final data = Uint8List.fromList([255, 254, 253, 252, 251]);
      final encoded = base64UrlNoPadEncode(data);
      final decoded = base64UrlNoPadDecode(encoded);
      expect(decoded, data);
    });

    test('Empty input encoding and decoding', () {
      final data = Uint8List(0);
      final encoded = base64UrlNoPadEncode(data);
      final decoded = base64UrlNoPadDecode(encoded);
      expect(decoded, data);
    });

    test('Decoding should properly add padding when necessary', () {
      const encoded = 'c29tZVRleHQ'; // 'someText' in base64Url without padding
      final decoded = base64UrlNoPadDecode(encoded);
      expect(
        decoded,
        Uint8List.fromList(
          [115, 111, 109, 101, 84, 101, 120, 116],
        ),
      ); // 'someText'
    });
  });
}
