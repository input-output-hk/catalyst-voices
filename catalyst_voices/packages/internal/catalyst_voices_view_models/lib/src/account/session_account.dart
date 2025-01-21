import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class SessionAccount extends Equatable {
  final String initials;
  final bool isAdmin;
  final bool isProposer;
  final bool isDrep;

  const SessionAccount({
    this.initials = '',
    this.isAdmin = false,
    this.isProposer = false,
    this.isDrep = false,
  });

  const SessionAccount.mocked()
      : this(
          initials: 'C',
          isAdmin: true,
          isProposer: true,
        );

  factory SessionAccount.fromAccount(Account account) {
    return SessionAccount(
      initials: account.displayName.isNotEmpty
          ? account.displayName.substring(0, 1)
          : '',
      isAdmin: account.isAdmin,
      isProposer: account.roles.contains(AccountRole.proposer),
      isDrep: account.roles.contains(AccountRole.drep),
    );
  }

  @override
  List<Object?> get props => [
        initials,
        isAdmin,
        isProposer,
        isDrep,
      ];
}
