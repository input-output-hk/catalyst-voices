import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:test/test.dart';

import 'test_utils/test_data.dart';

void main() {
  group(ShelleyAddress, () {
    test('round-trip conversion from and to bytes', () {
      expect(
        ShelleyAddress(mainnetAddr.bytes),
        equals(mainnetAddr),
      );

      expect(
        ShelleyAddress(testnetAddr.bytes),
        equals(testnetAddr),
      );

      expect(
        ShelleyAddress(mainnetStakeAddr.bytes),
        equals(mainnetStakeAddr),
      );

      expect(
        ShelleyAddress(testnetStakeAddr.bytes),
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

    test('publicKeyHash from stake address', () {
      expect(
        mainnetStakeAddr.publicKeyHash,
        equals(
          Ed25519PublicKeyHash.fromHex(
            '337b62cfff6403a06a3acbc34f8c46003c69fe79a3628cefa9c47251',
          ),
        ),
      );
      expect(
        testnetStakeAddr.publicKeyHash,
        equals(
          Ed25519PublicKeyHash.fromHex(
            '337b62cfff6403a06a3acbc34f8c46003c69fe79a3628cefa9c47251',
          ),
        ),
      );
    });

    test('toString returns bech32', () {
      expect(mainnetAddr.toString(), equals(mainnetAddr.toBech32()));
      expect(testnetAddr.toString(), equals(testnetAddr.toBech32()));
      expect(mainnetStakeAddr.toString(), equals(mainnetStakeAddr.toBech32()));
      expect(testnetStakeAddr.toString(), equals(testnetStakeAddr.toBech32()));
    });
  });
}
