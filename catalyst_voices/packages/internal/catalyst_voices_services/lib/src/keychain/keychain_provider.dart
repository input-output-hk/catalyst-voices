import 'package:catalyst_voices_services/catalyst_voices_services.dart';

abstract interface class KeychainProvider {
  Future<Keychain> create(String id);

  Future<bool> exists(String id);

  Future<Keychain> get(String id);

  Future<List<Keychain>> getAll();
}
