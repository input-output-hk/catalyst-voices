import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class SeedPhraseStateData extends Equatable {
  final SeedPhrase? seedPhrase;
  final List<SeedPhraseWord> shuffledWords;
  final List<SeedPhraseWord> userWords;
  final bool isStoredConfirmed;
  final bool areUserWordsCorrect;

  const SeedPhraseStateData({
    this.seedPhrase,
    this.shuffledWords = const [],
    this.userWords = const [],
    this.isStoredConfirmed = false,
    this.areUserWordsCorrect = false,
  });

  bool get isLoading => seedPhrase == null;

  bool get isResetWordsEnabled => userWords.isNotEmpty;

  SeedPhraseStateData copyWith({
    Optional<SeedPhrase>? seedPhrase,
    List<SeedPhraseWord>? shuffledWords,
    List<SeedPhraseWord>? userWords,
    bool? isStoredConfirmed,
    bool? areUserWordsCorrect,
  }) {
    return SeedPhraseStateData(
      seedPhrase: seedPhrase.dataOr(this.seedPhrase),
      shuffledWords: shuffledWords ?? this.shuffledWords,
      userWords: userWords ?? this.userWords,
      isStoredConfirmed: isStoredConfirmed ?? this.isStoredConfirmed,
      areUserWordsCorrect: areUserWordsCorrect ?? this.areUserWordsCorrect,
    );
  }

  @override
  List<Object?> get props => [
        seedPhrase,
        shuffledWords,
        userWords,
        isStoredConfirmed,
        areUserWordsCorrect,
      ];
}
