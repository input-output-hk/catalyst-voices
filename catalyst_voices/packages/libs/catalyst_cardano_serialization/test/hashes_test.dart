import 'package:catalyst_cardano_serialization/src/certificate.dart';
import 'package:catalyst_cardano_serialization/src/hashes.dart';
import 'package:catalyst_cardano_serialization/src/transaction.dart';
import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';
import 'package:test/test.dart';

import 'test_utils/test_data.dart';

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

  group(TransactionInputsHash, () {
    const hexString = '4d3f576f26db29139981a69443c2325d';
    final bytes = hex.decode(hexString);

    test('from and to hex', () {
      final hash = TransactionInputsHash.fromHex(hexString);
      expect(hash.toHex(), equals(hexString));
    });

    test('from and to bytes', () {
      final hash = TransactionInputsHash.fromBytes(bytes: bytes);
      expect(hash.bytes, equals(bytes));
    });

    test('from transaction inputs', () {
      final hash = TransactionInputsHash.fromTransactionInputs({testUtxo()});
      expect(
        hash,
        equals(
          TransactionInputsHash.fromHex('7336167445e63489f9c477367fd7a529'),
        ),
      );
    });

    test('toCbor returns bytes', () {
      final hash = TransactionInputsHash.fromBytes(bytes: bytes);
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

  group(CertificateHash, () {
    const hexString = '4d3f576f26db29139981a69443c2325d';
    final bytes = hex.decode(hexString);

    test('from and to hex', () {
      final hash = CertificateHash.fromHex(hexString);
      expect(hash.toHex(), equals(hexString));
    });

    test('from and to bytes', () {
      final hash = CertificateHash.fromBytes(bytes: bytes);
      expect(hash.bytes, equals(bytes));
    });

    test('from X509 der certificate', () {
      final derCert = X509DerCertificate.fromHex(derCertHex);

      expect(
        CertificateHash.fromX509DerCertificate(derCert),
        equals(
          CertificateHash.fromHex('667e69bd56a0fbd2d4db363e3bb017a1'),
        ),
      );
    });

    test('from C509 certificate', () {
      final c509Cert = C509Certificate.fromHex(c509CertHex);

      expect(
        CertificateHash.fromC509Certificate(c509Cert),
        equals(
          CertificateHash.fromHex('431d7b744dcc4ac4359b7ee7ffa7be33'),
        ),
      );
    });

    test('toCbor returns bytes', () {
      final hash = CertificateHash.fromBytes(bytes: bytes);
      final encodedCbor = cbor.encode(hash.toCbor());
      final decodedCbor = cbor.decode(encodedCbor);
      expect(decodedCbor, isA<CborBytes>());
      expect((decodedCbor as CborBytes).bytes, equals(bytes));
    });
  });
}
