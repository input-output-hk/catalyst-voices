// ignore_for_file: avoid_positional_boolean_parameters

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class KeychainCreationCubit extends Cubit<CreateKeychain> {
  KeychainCreationCubit() : super(const CreateKeychain());

  set _seedPhraseState(SeedPhraseState newValue) {
    emit(state.copyWith(seedPhraseState: newValue));
  }

  SeedPhraseState get _seedPhraseState => state.seedPhraseState;

  void changeStage(CreateKeychainStage newValue) {
    if (state.stage != newValue) {
      emit(state.copyWith(stage: newValue));
    }
  }

  void buildSeedPhrase() {
    final seedPhrase = SeedPhrase();
    _seedPhraseState = _seedPhraseState.copyWith(
      seedPhrase: Optional.of(seedPhrase),
    );
  }

  void ensureSeedPhraseCreated() {
    if (_seedPhraseState.seedPhrase == null) {
      buildSeedPhrase();
    }
  }

  void setSeedPhraseStoredConfirmed(bool newValue) {
    if (_seedPhraseState.isStoredConfirmed != newValue) {
      _seedPhraseState = _seedPhraseState.copyWith(isStoredConfirmed: newValue);
    }
  }

  CreateKeychainStep? nextStep() {
    final currentStageIndex = CreateKeychainStage.values.indexOf(state.stage);
    final isLast = currentStageIndex == CreateKeychainStage.values.length - 1;
    if (isLast) {
      return null;
    }

    final nextStage = CreateKeychainStage.values[currentStageIndex + 1];
    return CreateKeychainStep(stage: nextStage);
  }

  CreateKeychainStep? previousStep() {
    final currentStageIndex = CreateKeychainStage.values.indexOf(state.stage);
    final isFirst = currentStageIndex == 0;
    if (isFirst) {
      return null;
    }

    final previousStage = CreateKeychainStage.values[currentStageIndex - 1];
    return CreateKeychainStep(stage: previousStage);
  }
}
