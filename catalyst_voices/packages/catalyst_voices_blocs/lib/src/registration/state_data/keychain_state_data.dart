import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class KeychainStateData extends Equatable {
  final SeedPhraseStateData seedPhraseStateData;
  final UnlockPasswordState unlockPasswordState;

  const KeychainStateData({
    this.seedPhraseStateData = const SeedPhraseStateData(),
    this.unlockPasswordState = const UnlockPasswordState(),
  });

  /// Returns the seed phrase generated for the user.
  SeedPhrase? get seedPhrase => seedPhraseStateData.seedPhrase;

  KeychainStateData copyWith({
    SeedPhraseStateData? seedPhraseStateData,
    UnlockPasswordState? unlockPasswordState,
  }) {
    return KeychainStateData(
      seedPhraseStateData: seedPhraseStateData ?? this.seedPhraseStateData,
      unlockPasswordState: unlockPasswordState ?? this.unlockPasswordState,
    );
  }

  @override
  List<Object?> get props => [
        seedPhraseStateData,
        unlockPasswordState,
      ];
}
