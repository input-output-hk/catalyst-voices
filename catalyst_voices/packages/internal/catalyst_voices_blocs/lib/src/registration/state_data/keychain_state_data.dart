import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:equatable/equatable.dart';

final class KeychainStateData extends Equatable {
  final SeedPhraseStateData seedPhraseStateData;
  final UnlockPasswordState unlockPasswordState;

  const KeychainStateData({
    this.seedPhraseStateData = const SeedPhraseStateData(),
    this.unlockPasswordState = const UnlockPasswordState(),
  });

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
