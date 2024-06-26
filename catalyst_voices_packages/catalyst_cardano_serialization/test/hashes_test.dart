import 'package:catalyst_cardano_serialization/src/hashes.dart';
import 'package:catalyst_cardano_serialization/src/transaction.dart';
import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';
import 'package:test/test.dart';

void main() {
  group(TransactionHash, () {
    const hexString =
        '4d3f576f26db29139981a69443c2325daa812cc353a31b5a4db794a5bcbb06c2';
    final bytes = hex.decode(hexString);

    test('from and to hex', () {
      final hash = TransactionHash.fromHex(hexString);
      expect(hash.toHex(), equals(hexString));
    });

    test('from and to bytes', () {
      final hash = TransactionHash.fromBytes(bytes: bytes);
      expect(hash.bytes, equals(bytes));
    });

    test('from transaction body', () {
      const body = TransactionBody(
        inputs: {},
        outputs: [],
        fee: Coin(0),
      );

      final hash = TransactionHash.fromTransactionBody(body);
      expect(
        hash,
        equals(
          TransactionHash.fromHex(
            '36fdff68dfe3660f1ceea60f018a0fd7a83da13def229108794c397a879b0436',
          ),
        ),
      );
    });

    test('toCbor returns bytes', () {
      final hash = TransactionHash.fromBytes(bytes: bytes);
      final encodedCbor = cbor.encode(hash.toCbor());
      final decodedCbor = cbor.decode(encodedCbor);
      expect(decodedCbor, isA<CborBytes>());
      expect((decodedCbor as CborBytes).bytes, equals(bytes));
    });
  });

  group(AuxiliaryDataHash, () {
    const hexString =
        '4d3f576f26db29139981a69443c2325daa812cc353a31b5a4db794a5bcbb06c2';
    final bytes = hex.decode(hexString);

    test('from and to hex', () {
      final hash = AuxiliaryDataHash.fromHex(hexString);
      expect(hash.toHex(), equals(hexString));
    });

    test('from and to bytes', () {
      final hash = AuxiliaryDataHash.fromBytes(bytes: bytes);
      expect(hash.bytes, equals(bytes));
    });

    test('from auxiliary data', () {
      final data = AuxiliaryData(
        map: {
          const CborSmallInt(1): CborString('Test'),
        },
      );

      final hash = AuxiliaryDataHash.fromAuxiliaryData(data);
      expect(
        hash,
        equals(
          AuxiliaryDataHash.fromHex(
            '568d2b7d4052f6ce9f2c60b942b10da9d19e60c8bf24b17aa7bcfb3caffcc1ea',
          ),
        ),
      );
    });

    test('toCbor returns bytes', () {
      final hash = AuxiliaryDataHash.fromBytes(bytes: bytes);
      final encodedCbor = cbor.encode(hash.toCbor());
      final decodedCbor = cbor.decode(encodedCbor);
      expect(decodedCbor, isA<CborBytes>());
      expect((decodedCbor as CborBytes).bytes, equals(bytes));
    });
  });
}
