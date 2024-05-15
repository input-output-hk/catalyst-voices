import 'package:catalyst_cardano_serialization/src/address.dart';
import 'package:catalyst_cardano_serialization/src/types.dart';
import 'package:test/test.dart';

import 'utils/test_data.dart';

void main() {
  group(ShelleyAddress, () {
    test('round-trip conversion from and to bytes', () {
      expect(
        ShelleyAddress(mainnetAddr.bytes, hrp: mainnetAddr.hrp),
        equals(mainnetAddr),
      );

      expect(
        ShelleyAddress(testnetAddr.bytes, hrp: testnetAddr.hrp),
        equals(testnetAddr),
      );

      expect(
        ShelleyAddress(mainnetStakeAddr.bytes, hrp: mainnetStakeAddr.hrp),
        equals(mainnetStakeAddr),
      );

      expect(
        ShelleyAddress(testnetStakeAddr.bytes, hrp: testnetStakeAddr.hrp),
        equals(testnetStakeAddr),
      );
    });

    test('round-trip conversion from and to bech32', () {
      expect(
        ShelleyAddress.fromBech32(mainnetAddr.toBech32()),
        equals(mainnetAddr),
      );

      expect(
        ShelleyAddress.fromBech32(testnetAddr.toBech32()),
        equals(testnetAddr),
      );

      expect(
        ShelleyAddress.fromBech32(mainnetStakeAddr.toBech32()),
        equals(mainnetStakeAddr),
      );

      expect(
        ShelleyAddress.fromBech32(testnetStakeAddr.toBech32()),
        equals(testnetStakeAddr),
      );
    });

    test('hrp from address', () {
      expect(mainnetAddr.hrp, equals('addr'));
      expect(testnetAddr.hrp, equals('addr_test'));
      expect(mainnetStakeAddr.hrp, equals('stake'));
      expect(testnetStakeAddr.hrp, equals('stake_test'));
    });

    test('network ID from address', () {
      expect(mainnetAddr.network, equals(NetworkId.mainnet));
      expect(testnetAddr.network, equals(NetworkId.testnet));
      expect(mainnetStakeAddr.network, equals(NetworkId.mainnet));
      expect(testnetStakeAddr.network, equals(NetworkId.testnet));
    });

    test('toString returns bech32', () {
      expect(mainnetAddr.toString(), equals(mainnetAddr.toBech32()));
      expect(testnetAddr.toString(), equals(testnetAddr.toBech32()));
      expect(mainnetStakeAddr.toString(), equals(mainnetStakeAddr.toBech32()));
      expect(testnetStakeAddr.toString(), equals(testnetStakeAddr.toBech32()));
    });
  });
}
