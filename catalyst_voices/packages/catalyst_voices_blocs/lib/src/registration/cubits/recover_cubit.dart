// ignore_for_file: one_member_abstracts

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract interface class RecoverManager {
  Future<void> checkLocalKeychains();

  void setSeedPhraseWords(List<String> words);
}

final class RecoverCubit extends Cubit<RecoverStateData>
    implements RecoverManager {
  RecoverCubit() : super(const RecoverStateData()) {
    /// pre-populate all available words
    emit(state.copyWith(seedPhraseWords: SeedPhrase.wordList));
  }

  @override
  Future<void> checkLocalKeychains() async {
    // TODO(damian-molinski): Not implemented
  }

  @override
  void setSeedPhraseWords(List<String> words) {
    final newState = state.copyWith(
      userSeedPhraseWords: words,
      isSeedPhraseValid: SeedPhrase.isValid(words: words),
    );

    emit(newState);
  }
}
