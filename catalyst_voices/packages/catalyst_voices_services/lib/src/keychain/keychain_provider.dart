import 'package:catalyst_voices_services/catalyst_voices_services.dart';

abstract interface class KeychainProvider {
  Future<Keychain> create(String id);

  Future<bool> exits(String id);

  Future<Keychain> get(String id);

  Future<List<Keychain>> findAll();
}
