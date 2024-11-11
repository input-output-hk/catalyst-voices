import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:convert/convert.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(CatalystKeyDerivation, () {
    const mnemonic = 'prevent company field green slot measure chief'
        ' hero apple task eagle sunset endorse dress seed';

    const keyDerivation = CatalystKeyDerivation();

    setUpAll(() async {
      await CatalystKeyDerivation.init();
    });

    testWidgets('deriveMasterKey and derivePublicKey', (tester) async {
      final xprv = await keyDerivation.deriveMasterKey(mnemonic: mnemonic);

      expect(xprv.bytes, isNotEmpty);
      expect(xprv.bytes, equals(hex.decode(xprv.toHex())));

      final xpub = await xprv.derivePublicKey();
      expect(xpub.bytes, isNotEmpty);
      expect(xpub.bytes, equals(hex.decode(xpub.toHex())));
    });

    testWidgets('deriveKeys, sign data and verify signature', (tester) async {
      final xprv = await keyDerivation.deriveMasterKey(mnemonic: mnemonic);
      final xpub = await xprv.derivePublicKey();

      const data = [1, 2, 3, 4];
      final sig = await xprv.sign(data);

      final xprvVerification = await xprv.verify(data, signature: sig);
      expect(xprvVerification, isTrue);

      final xpubVerification = await xpub.verify(data, signature: sig);
      expect(xpubVerification, isTrue);
    });

    testWidgets('derivePrivateKey', (tester) async {
      final xprv = await keyDerivation.deriveMasterKey(mnemonic: mnemonic);
      const path = "m/1852'/1815'/0'/2/0";
      final derivedXprv = await xprv.derivePrivateKey(path: path);
      expect(derivedXprv.bytes, isNotEmpty);
    });

    testWidgets('drop clears a key', (tester) async {
      final xprv = await keyDerivation.deriveMasterKey(mnemonic: mnemonic);

      expect(
        xprv.bytes.every((byte) => byte == 0),
        isFalse,
        reason: 'xprv is not cleared yet',
      );

      xprv.drop();

      expect(
        xprv.bytes.every((byte) => byte == 0),
        isTrue,
        reason: 'xprv is cleared now',
      );
    });
  });
}
