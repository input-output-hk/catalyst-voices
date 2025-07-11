import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

/// A keychain manager that can create new [Keychain] instances or fetch existing ones.
abstract interface class KeychainProvider {
  Future<Keychain> create(String id);

  Future<bool> exists(String id);

  Future<Keychain> get(String id);

  Future<List<Keychain>> getAll();
}
