import 'dart:convert';

import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:catalyst_cardano_serialization/src/utils/hex.dart';
import 'package:cbor/cbor.dart';
import 'package:convert/convert.dart';
import 'package:test/test.dart';

void main() {
  group(Coin, () {
    test('fromAda constructor', () {
      final coin = Coin.fromAda(123);
      expect(coin.ada, equals(123));
    });

    test('fromWholeAda constructor', () {
      const coin = Coin.fromWholeAda(123);
      expect(coin.ada, equals(123));
    });

    test('addition', () {
      expect(const Coin(3) + const Coin(100), equals(const Coin(103)));
      expect(const Coin(-100) + const Coin(100), equals(const Coin(0)));
    });

    test('subtraction', () {
      expect(const Coin(5) - const Coin(2), equals(const Coin(3)));
      expect(const Coin(10) - const Coin(27), equals(const Coin(-17)));
    });

    test('multiplication', () {
      expect(const Coin(3) * const Coin(6), equals(const Coin(18)));
      expect(const Coin(-5) * const Coin(7), equals(const Coin(-35)));
    });

    test('division', () {
      expect(const Coin(3) ~/ const Coin(2), equals(const Coin(1)));
      expect(const Coin(100) ~/ const Coin(50), equals(const Coin(2)));
    });

    test('comparison', () {
      expect(const Coin(3) > const Coin(2), isTrue);
      expect(const Coin(3) >= const Coin(3), isTrue);
      expect(const Coin(100) < const Coin(100), isFalse);
      expect(const Coin(100) <= const Coin(100), isTrue);
    });
  });

  group(Balance, () {
    test('value with native tokens deserialized from cbor', () {
      const nativeTokensValue = '821b00000002536918eca1581cff5b52ec72ff3c4f7ed'
          '39d1d1c504f4efa72c51ba34588a604d47408a14a536372616461436f696e1832';
      final cborValue = cbor.decode(hexDecode(nativeTokensValue));
      final value = Balance.fromCbor(cborValue);
      expect(value.coin, equals(const Coin(9989331180)));
      expect(value.multiAsset, isNotNull);
    });

    test('value without native tokens deserialized from cbor', () {
      const value = '1B00000002536918EC';
      final cborValue = cbor.decode(hexDecode(value));
      expect(Balance.fromCbor(cborValue).coin, equals(const Coin(9989331180)));
    });
  });

  group('$AssetName', () {
    test('hex asset name round trip produces same cbor', () {
      // Given
      final value = CborBytes(
        [
          200,
          8,
          224,
          219,
          215,
          147,
          62,
          106,
          252,
          98,
          34,
          82,
          226,
          159,
          236,
          183,
          53,
          248,
          42,
          50,
          135,
          132,
          161,
          55,
          147,
          45,
          102,
          104,
          209,
          39,
          190,
          73,
        ],
      );

      // When
      final assetName = AssetName.fromCbor(value);

      // Then
      final againAsCbor = assetName.toCbor();

      expect(againAsCbor, value);
    });

    group('toCbor', () {
      test('hex-encoded asset name encoding', () {
        // Given
        const name = 'c808e0dbd7933e6afc622252e29fecb735f82a328784a137932d6668d127be49';
        final bytes = CborBytes(hex.decode(name));

        // When
        final assetName = AssetName.fromCbor(bytes);

        // Then
        final asCbor = assetName.toCbor();
        expect(asCbor, bytes);
        expect(asCbor.bytes, hasLength(32));
      });

      test('utf8 name encoding', () {
        // Given
        const name = 'catalyst';
        final expected = CborBytes(utf8.encode(name));

        // When
        final assetName = AssetName.fromCbor(expected);

        // Then
        final asCbor = assetName.toCbor();
        expect(asCbor, expected);
        expect(asCbor.bytes, hasLength(8));
      });

      test('mixed case hex-encoded asset name', () {
        // Given
        const name = 'C808E0DBD7933E6AFC622252E29FECB735F82A328784A137932D6668D127BE49';
        final expected = CborBytes(hex.decode(name));

        // When
        final assetName = AssetName.fromCbor(expected);

        // Then
        final asCbor = assetName.toCbor();
        expect(asCbor, expected);
        expect(asCbor.bytes, hasLength(32));
      });

      test('invalid hex (odd length)', () {
        // Given
        const name = 'abc';
        final expected = CborBytes(utf8.encode(name));

        // When
        final assetName = AssetName(name);

        // Then
        final asCbor = assetName.toCbor();
        expect(asCbor, expected);
      });

      test('invalid hex (non-hex chars)', () {
        // Given
        const name = 'abcxyz';
        final expected = CborBytes(utf8.encode(name));

        // When
        final assetName = AssetName(name);

        // Then
        final asCbor = assetName.toCbor();
        expect(asCbor, expected);
      });
    });

    group('fromCbor', () {
      test('hex-encoded asset name decoding', () {
        // Given
        final value = CborBytes(
          [
            200,
            8,
            224,
            219,
            215,
            147,
            62,
            106,
            252,
            98,
            34,
            82,
            226,
            159,
            236,
            183,
            53,
            248,
            42,
            50,
            135,
            132,
            161,
            55,
            147,
            45,
            102,
            104,
            209,
            39,
            190,
            73,
          ],
        );
        final expectedName = hex.encode(value.bytes);

        // When
        final assetName = AssetName.fromCbor(value);

        // Then
        expect(assetName.name, expectedName);
        expect(assetName.toCbor().bytes, hasLength(32));
      });

      test('utf8-encoded asset name decoding', () {
        // Given
        const name = 'catalyst';
        final value = CborBytes(utf8.encode(name));

        // When
        final assetName = AssetName.fromCbor(value);

        // Then
        expect(assetName.name, name);
      });

      test('empty name', () {
        // Given
        final value = CborBytes([]);

        // When
        final assetName = AssetName.fromCbor(value);

        // Then
        expect(assetName.name, isEmpty);
      });
    });

    group('name', () {
      test('utf8 is decoded as for as normal string', () {
        // Given
        const name = 'catalyst';
        final bytes = utf8.encode(name);

        // When
        final assetName = AssetName.bytes(bytes);

        // Then
        expect(assetName.name, name);
      });
      test('hex is decoded as for as normal string', () {
        // Given
        const name = 'c808e0dbd7933e6afc622252e29fecb735f82a328784a137932d6668d127be49';
        final bytes = hexDecode(name);

        // When
        final assetName = AssetName.bytes(bytes);

        // Then
        expect(assetName.name, name);
      });
    });

    group('isTooLong', () {
      test('returns false for regular hex', () {
        // Given
        const name = 'c808e0dbd7933e6afc622252e29fecb735f82a328784a137932d6668d127be49';

        // When
        final bytes = hex.decode(name);
        final assetName = AssetName.fromCbor(CborBytes(bytes));

        // Then
        expect(assetName.isTooLong, false);
      });

      test('returns false for regular string', () {
        // Given
        const name = 'catalyst';

        // When
        final bytes = utf8.encode(name);
        final assetName = AssetName.fromCbor(CborBytes(bytes));

        // Then
        expect(assetName.isTooLong, false);
      });

      test('returns true for double hex decoded and encoded as utf8', () {
        // Given
        const name = 'c808e0dbd7933e6afc622252e29fecb735f82a328784a137932d6668d127be49';

        // When
        final utf8Bytes = utf8.encode(name);
        final assetName = AssetName.fromCbor(CborBytes(utf8Bytes));

        // Then
        expect(assetName.isTooLong, isTrue);
      });
    });
  });
}
