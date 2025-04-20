import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/src/catalyst_voices_models.dart';
import 'package:test/test.dart';

void main() {
  group(CardanoAddressUri, () {
    final address = ShelleyAddress.fromBech32(
      /* cSpell:disable */
      'addr_test1vzpwq95z3xyum8vqndgdd'
      '9mdnmafh3djcxnc6jemlgdmswcve6tkw',
      /* cSpell:enable */
    );

    test('toString outputs formatted uri', () {
      final uri = CardanoAddressUri(address);

      expect(
        uri.toString(),
        equals(
          /* cSpell:disable */
          'web+cardano://addr/addr_test1vzpwq95z3xyum8v'
          'qndgdd9mdnmafh3djcxnc6jemlgdmswcve6tkw',
          /* cSpell:enable */
        ),
      );
    });

    test('isCardanoAddressUri check whether uri has the right format', () {
      final uriString = CardanoAddressUri(address).toString();
      expect(CardanoAddressUri.isCardanoAddressUri(uriString), isTrue);
      expect(
        CardanoAddressUri.isCardanoAddressUri('https://invalid-uri.com'),
        isFalse,
      );
    });

    test('address uri can be encoded / decoded from string', () {
      final uri = CardanoAddressUri(address);
      final uriString = uri.toString();
      final decodedUri = CardanoAddressUri.fromString(uriString);

      expect(decodedUri, equals(uri));
    });
  });
}
