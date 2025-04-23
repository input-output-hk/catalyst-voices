import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';
import 'package:result_type/result_type.dart';

final class AccountSummaryData extends Equatable {
  final String? username;
  final String? email;
  final Set<AccountRole> roles;
  final String? address;
  final String? clipboardAddress;
  final String? balance;

  const AccountSummaryData({
    required this.username,
    required this.email,
    required this.roles,
    required this.address,
    required this.clipboardAddress,
    required this.balance,
  });

  @override
  List<Object?> get props => [
        username,
        email,
        roles,
        address,
        clipboardAddress,
        balance,
      ];
}

final class RecoverStateData extends Equatable {
  final bool foundKeychain;
  final List<SeedPhraseWord> userSeedPhraseWords;
  final List<String> seedPhraseWords;
  final bool isSeedPhraseValid;
  final Result<AccountSummaryData, LocalizedException>? accountDetails;
  final UnlockPasswordState unlockPasswordState;

  const RecoverStateData({
    this.foundKeychain = false,
    this.userSeedPhraseWords = const [],
    this.seedPhraseWords = const [],
    this.isSeedPhraseValid = false,
    this.accountDetails,
    this.unlockPasswordState = const UnlockPasswordState(),
  });

  bool get isAccountSummaryNextEnabled => accountDetails?.isSuccess ?? false;

  @override
  List<Object?> get props => [
        foundKeychain,
        userSeedPhraseWords,
        seedPhraseWords,
        isSeedPhraseValid,
        accountDetails,
        unlockPasswordState,
      ];

  RecoverStateData copyWith({
    bool? foundKeychain,
    List<SeedPhraseWord>? userSeedPhraseWords,
    List<String>? seedPhraseWords,
    bool? isSeedPhraseValid,
    Optional<Result<AccountSummaryData, LocalizedException>>? accountDetails,
    UnlockPasswordState? unlockPasswordState,
  }) {
    return RecoverStateData(
      foundKeychain: foundKeychain ?? this.foundKeychain,
      userSeedPhraseWords: userSeedPhraseWords ?? this.userSeedPhraseWords,
      seedPhraseWords: seedPhraseWords ?? this.seedPhraseWords,
      isSeedPhraseValid: isSeedPhraseValid ?? this.isSeedPhraseValid,
      accountDetails: accountDetails.dataOr(this.accountDetails),
      unlockPasswordState: unlockPasswordState ?? this.unlockPasswordState,
    );
  }

  @override
  String toString() {
    return 'RecoverStateData('
        '$foundKeychain, '
        '$userSeedPhraseWords, '
        // Note. do not print because this list is often very large.
        '${seedPhraseWords.length}, '
        '$isSeedPhraseValid, '
        '$accountDetails, '
        '$unlockPasswordState, '
        ')';
  }
}
