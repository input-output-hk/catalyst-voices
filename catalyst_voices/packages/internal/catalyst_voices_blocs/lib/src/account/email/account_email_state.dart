import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class AccountEmailState extends Equatable {
  final Account? account;

  const AccountEmailState({this.account});

  @override
  List<Object?> get props => [account];

  bool get showDiscoveryEmailVerificationBanner {
    if (account == null) {
      return false;
    }

    final isEmailProvided = account?.email?.isNotEmpty ?? false;

    if (isEmailProvided && !_isEmailVerified && !_isProposer) {
      return true;
    }

    return showProposerEmailVerificationBanner;
  }

  bool get showProposerEmailVerificationBanner {
    if (account == null) {
      return false;
    }
    if (_isProposer && !_isEmailVerified) {
      return true;
    }

    return false;
  }

  bool get _isEmailVerified => account?.publicStatus.isVerified ?? false;
  bool get _isProposer => account?.hasRole(AccountRole.proposer) ?? false;

  AccountEmailState copyWith({Optional<Account>? account}) {
    return AccountEmailState(account: account.dataOr(this.account));
  }
}
