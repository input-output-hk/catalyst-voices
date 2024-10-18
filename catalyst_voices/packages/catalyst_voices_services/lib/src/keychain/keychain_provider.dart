import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';

abstract interface class KeychainProvider {
  Future<Keychain> create(
    String id, {
    required SeedPhrase seedPhrase,
    required LockFactor lockFactor,
  });

  Future<bool> exits(String id);

  Future<Keychain> get(String id);

  Future<List<Keychain>> findAll();
}
