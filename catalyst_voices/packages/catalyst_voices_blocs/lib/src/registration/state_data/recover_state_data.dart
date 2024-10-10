import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class RecoverStateData extends Equatable {
  final bool foundKeychain;
  final List<SeedPhraseWord> userSeedPhraseWords;
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
    List<SeedPhraseWord>? userSeedPhraseWords,
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
  String toString() {
    return 'RecoverStateData($foundKeychain, $userSeedPhraseWords, '
        '${seedPhraseWords.length}, $isSeedPhraseValid,)';
  }

  @override
  List<Object?> get props => [
        foundKeychain,
        userSeedPhraseWords,
        seedPhraseWords,
        isSeedPhraseValid,
      ];
}
