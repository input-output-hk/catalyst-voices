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

  // Just putting in class ref fails for some reason.
  group('$AssetName', () {
    const hexAssetNameCborBytes = [
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
    ];

    test('hex asset name is decoded', () {
      // Given
      final value = CborBytes(hexAssetNameCborBytes);
      final expectedName = hex.encode(value.bytes);

      // When
      final assetName = AssetName.fromCbor(value);

      // Then
      expect(assetName.name, expectedName);
    });

    test('hex asset name round trip produces same cbor', () {
      // Given
      final value = CborBytes(hexAssetNameCborBytes);

      // When
      final assetName = AssetName.fromCbor(value);

      // Then
      final againAsCbor = assetName.toCbor();

      expect(againAsCbor, value);
    });

    test('double hex encode asset name returns too long true', () {
      // Given
      final encoded = hex.encode(hexAssetNameCborBytes);
      final doubleEncoded = hex.encode(CborString(encoded).utf8Bytes);

      // When
      final assetName = AssetName(doubleEncoded);

      // Then
      expect(assetName.isTooLong, isTrue);
    });
  });
}
