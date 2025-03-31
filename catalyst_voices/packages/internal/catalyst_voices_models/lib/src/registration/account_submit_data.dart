import 'package:catalyst_cardano/catalyst_cardano.dart';
import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

sealed class AccountSubmitData {
  final AccountSubmitMetadata metadata;

  const AccountSubmitData({
    required this.metadata,
  });
}

final class AccountSubmitFullData extends AccountSubmitData {
  final Keychain keychain;
  final String username;
  final String email;
  final Set<AccountRole> roles;

  const AccountSubmitFullData({
    required super.metadata,
    required this.keychain,
    required this.username,
    required this.email,
    required this.roles,
  });
}

final class AccountSubmitMetadata {
  final CardanoWallet wallet;
  final Transaction transaction;

  const AccountSubmitMetadata({
    required this.wallet,
    required this.transaction,
  });
}

final class AccountSubmitUpdateData extends AccountSubmitData {
  final CatalystId accountId;
  final Set<AccountRole> roles;

  const AccountSubmitUpdateData({
    required super.metadata,
    required this.accountId,
    required this.roles,
  });
}
