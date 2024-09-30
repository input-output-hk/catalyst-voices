// ignore_for_file: avoid_positional_boolean_parameters

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class KeychainCreationCubit extends Cubit<CreateKeychain> {
  CreateKeychainStage _stage;
  SeedPhrase? _seedPhrase;
  bool _isSeedPhraseStoredConfirmed = false;

  KeychainCreationCubit()
      : _stage = CreateKeychainStage.splash,
        super(const CreateKeychain());

  void changeStage(CreateKeychainStage newValue) {
    if (_stage != newValue) {
      _stage = newValue;
      emit(_buildState());
    }
  }

  void buildSeedPhrase() {
    _seedPhrase = SeedPhrase();
    emit(_buildState());
  }

  void ensureSeedPhraseCreated() {
    if (_seedPhrase == null) {
      buildSeedPhrase();
    }
  }

  void setSeedPhraseStoredConfirmed(bool newValue) {
    if (_isSeedPhraseStoredConfirmed != newValue) {
      _isSeedPhraseStoredConfirmed = newValue;
      emit(_buildState());
    }
  }

  CreateKeychainStep? nextStep() {
    final currentStageIndex = CreateKeychainStage.values.indexOf(_stage);
    final isLast = currentStageIndex == CreateKeychainStage.values.length - 1;
    if (isLast) {
      return null;
    }

    final nextStage = CreateKeychainStage.values[currentStageIndex + 1];
    return CreateKeychainStep(stage: nextStage);
  }

  CreateKeychainStep? previousStep() {
    final currentStageIndex = CreateKeychainStage.values.indexOf(_stage);
    final isFirst = currentStageIndex == 0;
    if (isFirst) {
      return null;
    }

    final previousStage = CreateKeychainStage.values[currentStageIndex - 1];
    return CreateKeychainStep(stage: previousStage);
  }

  CreateKeychain _buildState() {
    return CreateKeychain(
      stage: _stage,
      seedPhraseState: SeedPhraseState(
        seedPhrase: _seedPhrase,
        isStoredConfirmed: _isSeedPhraseStoredConfirmed,
      ),
    );
  }
}
