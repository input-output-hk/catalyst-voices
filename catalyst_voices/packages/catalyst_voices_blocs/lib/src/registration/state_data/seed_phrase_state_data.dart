import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class SeedPhraseStateData extends Equatable {
  final List<SeedPhraseWord> seedPhraseWords;
  final List<SeedPhraseWord> shuffledWords;
  final List<SeedPhraseWord> userWords;
  final bool isStoredConfirmed;
  final bool areUserWordsCorrect;

  const SeedPhraseStateData({
    this.seedPhraseWords = const [],
    this.shuffledWords = const [],
    this.userWords = const [],
    this.isStoredConfirmed = false,
    this.areUserWordsCorrect = false,
  });

  bool get isLoading => seedPhraseWords.isEmpty;

  bool get isResetWordsEnabled => userWords.isNotEmpty;

  SeedPhraseStateData copyWith({
    List<SeedPhraseWord>? seedPhraseWords,
    List<SeedPhraseWord>? shuffledWords,
    List<SeedPhraseWord>? userWords,
    bool? isStoredConfirmed,
    bool? areUserWordsCorrect,
  }) {
    return SeedPhraseStateData(
      seedPhraseWords: seedPhraseWords ?? this.seedPhraseWords,
      shuffledWords: shuffledWords ?? this.shuffledWords,
      userWords: userWords ?? this.userWords,
      isStoredConfirmed: isStoredConfirmed ?? this.isStoredConfirmed,
      areUserWordsCorrect: areUserWordsCorrect ?? this.areUserWordsCorrect,
    );
  }

  @override
  List<Object?> get props => [
        seedPhraseWords,
        shuffledWords,
        userWords,
        isStoredConfirmed,
        areUserWordsCorrect,
      ];
}
