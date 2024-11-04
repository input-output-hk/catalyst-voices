import 'package:catalyst_cardano_serialization/src/utils/cbor.dart';
import 'package:test/test.dart';

void main() {
  group(CborSize, () {
    test('of int value', () {
      expect(CborSize.ofInt(0), equals(CborSize.inline));
      expect(
        CborSize.ofInt(CborSize.maxInlineEncoding),
        equals(CborSize.inline),
      );
      expect(CborSize.ofInt(0xff), equals(CborSize.one));
      expect(CborSize.ofInt(0x100), equals(CborSize.two));
      expect(CborSize.ofInt(0xffff), equals(CborSize.two));
      expect(CborSize.ofInt(0x10000), equals(CborSize.four));
      expect(CborSize.ofInt(0xffffffff), equals(CborSize.four));
      expect(CborSize.ofInt(0x100000000), equals(CborSize.eight));
      expect(CborSize.ofInt(0xfffffffffffff), equals(CborSize.eight));
    });

    test('bytes length', () {
      expect(CborSize.inline.bytes, equals(0));
      expect(CborSize.one.bytes, equals(1));
      expect(CborSize.two.bytes, equals(2));
      expect(CborSize.four.bytes, equals(4));
      expect(CborSize.eight.bytes, equals(8));
    });
  });
}
