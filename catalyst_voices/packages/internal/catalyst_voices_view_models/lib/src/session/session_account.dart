import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class SessionAccount extends Equatable {
  final String displayName;
  final bool isAdmin;
  final bool isProposer;
  final bool isDrep;

  const SessionAccount({
    this.displayName = '',
    this.isAdmin = false,
    this.isProposer = false,
    this.isDrep = false,
  });

  const SessionAccount.mocked()
      : this(
          displayName: 'Account Mocked',
          isAdmin: true,
          isProposer: true,
        );

  factory SessionAccount.fromAccount(Account account) {
    return SessionAccount(
      displayName: account.displayName,
      isAdmin: account.isAdmin,
      isProposer: account.roles.contains(AccountRole.proposer),
      isDrep: account.roles.contains(AccountRole.drep),
    );
  }

  String get initials {
    return displayName.isNotEmpty ? displayName.substring(0, 1) : '';
  }

  @override
  List<Object?> get props => [
        displayName,
        isAdmin,
        isProposer,
        isDrep,
      ];
}
