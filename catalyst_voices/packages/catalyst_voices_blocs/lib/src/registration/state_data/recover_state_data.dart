import 'package:equatable/equatable.dart';

final class RecoverStateData extends Equatable {
  final bool foundKeychain;
  final List<String> userSeedPhraseWords;
  final List<String> seedPhraseWords;
  final bool isSeedPhraseValid;

  const RecoverStateData({
    this.foundKeychain = false,
    this.userSeedPhraseWords = const [],
    this.seedPhraseWords = const [],
    this.isSeedPhraseValid = false,
  });

  RecoverStateData copyWith({
    bool? foundKeychain,
    List<String>? userSeedPhraseWords,
    List<String>? seedPhraseWords,
    bool? isSeedPhraseValid,
  }) {
    return RecoverStateData(
      foundKeychain: foundKeychain ?? this.foundKeychain,
      userSeedPhraseWords: userSeedPhraseWords ?? this.userSeedPhraseWords,
      seedPhraseWords: seedPhraseWords ?? this.seedPhraseWords,
      isSeedPhraseValid: isSeedPhraseValid ?? this.isSeedPhraseValid,
    );
  }

  @override
  List<Object?> get props => [
        foundKeychain,
        userSeedPhraseWords,
        seedPhraseWords,
        isSeedPhraseValid,
      ];
}
