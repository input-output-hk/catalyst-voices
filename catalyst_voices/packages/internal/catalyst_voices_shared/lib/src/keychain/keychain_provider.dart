import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

abstract interface class KeychainProvider {
  Future<Keychain> create(String id);

  Future<bool> exists(String id);

  Future<Keychain> get(String id);

  Future<List<Keychain>> getAll();
}
