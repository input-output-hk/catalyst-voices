import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices/dependency/dependencies.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';

// Add more test accounts here.
abstract final class TestAccounts {
  TestAccounts._();

  static Future<Account> create({
    required SeedPhrase seedPhrase,
    required LockFactor lockFactor,
    String? email,
    String? username,
    String? keychainId,
    Set<AccountRole>? roles,
    ShelleyAddress? address,
    AccountPublicStatus? publicStatus,
  }) {
    assert(
      roles == null || roles.contains(AccountRole.root),
      'Minimum root account role is required',
    );

    return Dependencies.instance.get<RegistrationService>().createAccount(
          seedPhrase: seedPhrase,
          lockFactor: lockFactor,
          email: email,
          username: username,
          keychainId: keychainId,
          roles: roles,
          address: address,
          publicStatus: publicStatus,
        );
  }

  static Future<Account> dummyAccount() {
    return Dependencies.instance.get<RegistrationService>().createDummyAccount();
  }
}
