/// Fake and mock implementations of keychain interfaces for testing.
library;

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:mocktail/mocktail.dart';

/// A fake implementation of [KeychainSigner] for testing.
///
/// This is a minimal fake that extends Fake and implements KeychainSigner.
/// Use mocktail's `when` to stub specific method behaviors as needed.
class FakeKeychainSigner extends Fake implements KeychainSigner {}

/// A mock implementation of [Keychain] using mocktail.
///
/// Use this when you need to verify interactions or stub specific behaviors.
class MockKeychain extends Mock implements Keychain {}
