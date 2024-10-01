import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_shared/src/formatter/wallet_address_formatter.dart';
import 'package:test/test.dart';

void main() {
  group(WalletAddressFormatter, () {
    test('should format ShelleyAddress into short representation', () {
      /* cSpell:disable */
      final address = ShelleyAddress.fromBech32(
        'addr_test1vzpwq95z3xyum8vqndgdd'
        '9mdnmafh3djcxnc6jemlgdmswcve6tkw',
      );
      /* cSpell:enable */

      expect(
        WalletAddressFormatter.formatShort(address),
        equals('addr_test1v…6tkw'),
      );
    });
  });
}
