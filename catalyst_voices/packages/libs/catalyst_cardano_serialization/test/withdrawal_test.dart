import 'dart:typed_data';

import 'package:catalyst_cardano_serialization/src/address.dart';
import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:catalyst_cardano_serialization/src/utils/cbor.dart';
import 'package:catalyst_cardano_serialization/src/withdrawal.dart';
import 'package:cbor/cbor.dart';
import 'package:test/test.dart';

void main() {
  // 1 header byte (0xE0 = mainnet reward) + 28 zero bytes = valid reward address.
  final mainnetRewardBytes = Uint8List(29)..[0] = 0xE0;
  final mainnetRewardBytes2 = Uint8List(29)
    ..[0] = 0xE0
    ..[1] = 0x01;

  // 1 header byte (0xF0 = testnet reward) + 28 zero bytes = valid testnet reward address.
  final testnetRewardBytes = Uint8List(29)..[0] = 0xF0;

  // Enterprise address (0x60 header) — not a reward address.
  final enterpriseBytes = Uint8List(29)..[0] = 0x60;

  // Base address (0x00 header, 57 bytes) — not a reward address.
  final baseAddressBytes = Uint8List(57)..[0] = 0x00;

  ShelleyAddress rewardAddress(Uint8List bytes) => ShelleyAddress(bytes);

  final mainnetReward = rewardAddress(mainnetRewardBytes);
  final mainnetReward2 = rewardAddress(mainnetRewardBytes2);
  final testnetReward = rewardAddress(testnetRewardBytes);
  final enterprise = rewardAddress(enterpriseBytes);

  const coin100 = Coin(100);
  const coin200 = Coin(200);

  group('Withdrawals constructor', () {
    test('empty map is valid', () {
      expect(Withdrawals.new, returnsNormally);
      expect(Withdrawals().map, isEmpty);
    });

    test('single mainnet reward address is valid', () {
      expect(
        () => Withdrawals(map: {mainnetReward: coin100}),
        returnsNormally,
      );
    });

    test('single testnet reward address is valid', () {
      expect(
        () => Withdrawals(map: {testnetReward: coin100}),
        returnsNormally,
      );
    });

    test('multiple reward addresses are valid', () {
      expect(
        () => Withdrawals(
          map: {
            mainnetReward: coin100,
            mainnetReward2: coin200,
          },
        ),
        returnsNormally,
      );
    });

    test('throws ArgumentError for enterprise address', () {
      expect(
        () => Withdrawals(map: {enterprise: coin100}),
        throwsArgumentError,
      );
    });

    test('throws ArgumentError for base address', () {
      expect(
        () => Withdrawals(map: {ShelleyAddress(baseAddressBytes): coin100}),
        throwsArgumentError,
      );
    });

    test('throws ArgumentError if any address in map is invalid', () {
      expect(
        () => Withdrawals(
          map: {
            mainnetReward: coin100,
            enterprise: coin200, // invalid
          },
        ),
        throwsArgumentError,
      );
    });
  });

  group('Withdrawals equality', () {
    test('two withdrawals with same map are equal', () {
      final a = Withdrawals(map: {mainnetReward: coin100});
      final b = Withdrawals(map: {mainnetReward: coin100});
      expect(a, equals(b));
    });

    test('two withdrawals with different coins are not equal', () {
      final a = Withdrawals(map: {mainnetReward: coin100});
      final b = Withdrawals(map: {mainnetReward: coin200});
      expect(a, isNot(equals(b)));
    });

    test('two withdrawals with different addresses are not equal', () {
      final a = Withdrawals(map: {mainnetReward: coin100});
      final b = Withdrawals(map: {mainnetReward2: coin100});
      expect(a, isNot(equals(b)));
    });

    test('empty withdrawals are equal', () {
      expect(Withdrawals(), equals(Withdrawals()));
    });
  });

  group('Withdrawals.toCbor', () {
    test('empty map encodes with CborCustomTags.map tag', () {
      final cbor = Withdrawals().toCbor() as CborMap;
      expect(cbor.tags, contains(CborCustomTags.map));
      expect(cbor, isEmpty);
    });

    test('non-empty map encodes without extra tags by default', () {
      final cbor = Withdrawals(map: {mainnetReward: coin100}).toCbor() as CborMap;
      expect(cbor.tags, isEmpty);
      expect(cbor.length, 1);
    });

    test('keys encode as CborBytes', () {
      final cbor = Withdrawals(map: {mainnetReward: coin100}).toCbor() as CborMap;
      expect(cbor.keys.first, isA<CborBytes>());
    });

    test('values encode as CborUnsignedInt', () {
      final cbor = Withdrawals(map: {mainnetReward: coin100}).toCbor() as CborMap;
      expect(cbor.values.first, isA<CborSmallInt>());
    });

    test('encodes multiple entries', () {
      final cbor =
          Withdrawals(
                map: {
                  mainnetReward: coin100,
                  mainnetReward2: coin200,
                },
              ).toCbor()
              as CborMap;
      expect(cbor.length, 2);
    });

    test('passes through custom tags for non-empty map', () {
      final cbor = Withdrawals(map: {mainnetReward: coin100}).toCbor(tags: [42]) as CborMap;
      expect(cbor.tags, contains(42));
    });
  });

  group('Withdrawals.fromCbor', () {
    test('deserializes empty map', () {
      final cbor = CborMap({});
      final result = Withdrawals.fromCbor(cbor);
      expect(result.map, isEmpty);
    });

    test('deserializes single entry', () {
      final cbor = CborMap({
        CborBytes(mainnetRewardBytes): const CborSmallInt(100),
      });
      final result = Withdrawals.fromCbor(cbor);
      expect(result.map.length, 1);
      expect(result.map.keys.first, equals(mainnetReward));
      expect(result.map.values.first, equals(coin100));
    });

    test('deserializes multiple entries', () {
      final cbor = CborMap({
        CborBytes(mainnetRewardBytes): const CborSmallInt(100),
        CborBytes(mainnetRewardBytes2): const CborSmallInt(200),
      });
      final result = Withdrawals.fromCbor(cbor);
      expect(result.map.length, 2);
    });

    test('throws for non-reward address bytes', () {
      final cbor = CborMap({
        CborBytes(enterpriseBytes): const CborSmallInt(100),
      });
      expect(() => Withdrawals.fromCbor(cbor), throwsArgumentError);
    });
  });

  group('Withdrawals round-trip', () {
    test('empty map round-trips correctly', () {
      final original = Withdrawals();
      final restored = Withdrawals.fromCbor(original.toCbor());
      expect(restored, equals(original));
    });

    test('single entry round-trips correctly', () {
      final original = Withdrawals(map: {mainnetReward: coin100});
      final restored = Withdrawals.fromCbor(original.toCbor());
      expect(restored, equals(original));
    });

    test('multiple entries round-trip correctly', () {
      final original = Withdrawals(
        map: {
          mainnetReward: coin100,
          mainnetReward2: coin200,
        },
      );
      final restored = Withdrawals.fromCbor(original.toCbor());
      expect(restored, equals(original));
    });

    test('testnet reward address round-trips correctly', () {
      final original = Withdrawals(map: {testnetReward: coin100});
      final restored = Withdrawals.fromCbor(original.toCbor());
      expect(restored, equals(original));
    });
  });
}
