/// Fake and mock implementations of key derivation services for testing.
library;

import 'package:catalyst_voices_dev/src/crypto/catalyst_crypto_fakes.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

/// A fake implementation of [KeyDerivationService] for testing.
///
/// This fake returns predictable key pairs where both public and private keys
/// use the same bytes as the master key.
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

/// A mock implementation of [KeyDerivationService] using mocktail.
///
/// Use this when you need to verify interactions or stub specific behaviors.
class MockKeyDerivationService extends Mock implements KeyDerivationService {}
