import 'package:catalyst_voices_models/catalyst_voices_models.dart';

abstract interface class KeychainProvider {
  Future<Keychain> create(String id);

  Future<bool> exists(String id);

  Future<Keychain> get(String id);

  Future<List<Keychain>> getAll();
}
