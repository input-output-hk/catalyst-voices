import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class SessionAccount extends Equatable {
  final String catalystId;
  final String displayName;
  final bool isAdmin;
  final bool isProposer;
  final bool isDrep;

  const SessionAccount({
    this.catalystId = '',
    this.displayName = '',
    this.isAdmin = false,
    this.isProposer = false,
    this.isDrep = false,
  });

  const SessionAccount.mocked()
      : this(
          catalystId: 'cardano/uuid',
          displayName: 'Account Mocked',
          isAdmin: true,
          isProposer: true,
        );

  factory SessionAccount.fromAccount(Account account) {
    return SessionAccount(
      catalystId: account.catalystId,
      displayName: account.displayName,
      isAdmin: account.isAdmin,
      isProposer: account.roles.contains(AccountRole.proposer),
      isDrep: account.roles.contains(AccountRole.drep),
    );
  }

  @override
  List<Object?> get props => [
        catalystId,
        displayName,
        isAdmin,
        isProposer,
        isDrep,
      ];
}
