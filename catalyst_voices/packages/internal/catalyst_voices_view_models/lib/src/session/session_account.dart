import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:equatable/equatable.dart';

/// Represents the current session account.
///
/// This class is used to store information about the current session account,
/// including the catalyst id, admin status, proposer status, and drep status.
final class SessionAccount extends Equatable {
  final CatalystId? catalystId;
  final bool isAdmin;
  final bool isProposer;
  final bool isDrep;

  const SessionAccount({
    this.catalystId,
    this.isAdmin = false,
    this.isProposer = false,
    this.isDrep = false,
  });

  factory SessionAccount.fromAccount(Account account) {
    return SessionAccount(
      catalystId: account.catalystId,
      isAdmin: account.isAdmin,
      isProposer: account.roles.contains(AccountRole.proposer),
      isDrep: account.roles.contains(AccountRole.drep),
    );
  }

  factory SessionAccount.mocked() {
    return SessionAccount(
      catalystId: CatalystId(
        host: CatalystIdHost.cardano.host,
        username: 'Account Mocked',
        role0Key: base64UrlNoPadDecode('FftxFnOrj2qmTuB2oZG2v0YEWJfKvQ9Gg8AgNAhDsKE'),
      ),
      isAdmin: true,
      isProposer: true,
    );
  }

  @override
  List<Object?> get props => [
    catalystId,
    isAdmin,
    isProposer,
    isDrep,
  ];

  String? get username => catalystId?.username;
}
