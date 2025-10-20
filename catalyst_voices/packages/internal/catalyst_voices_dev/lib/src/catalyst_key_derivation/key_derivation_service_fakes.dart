import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:mocktail/mocktail.dart';

class FakeKeyDerivationService extends Fake implements KeyDerivationService {
  @override
  Future<CatalystKeyPair> deriveAccountRoleKeyPair({
    required CatalystPrivateKey masterKey,
    required AccountRole role,
  }) async {
    return CatalystKeyPair(
      publicKey: FakeCatalystPublicKey(bytes: masterKey.bytes),
      privateKey: FakeCatalystPrivateKey(bytes: masterKey.bytes),
    );
  }
}

class MockKeyDerivationService extends Mock implements KeyDerivationService {}
