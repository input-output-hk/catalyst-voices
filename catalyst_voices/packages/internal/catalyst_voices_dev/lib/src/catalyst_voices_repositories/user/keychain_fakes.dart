import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:mocktail/mocktail.dart';

class FakeKeychainSigner extends Fake implements KeychainSigner {}

class MockKeychain extends Mock implements Keychain {}
