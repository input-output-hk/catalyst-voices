import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:equatable/equatable.dart';

final class KeychainStateData extends Equatable {
  final SeedPhraseStateData seedPhraseStateData;

  const KeychainStateData({
    this.seedPhraseStateData = const SeedPhraseStateData(),
  });

  KeychainStateData copyWith({
    SeedPhraseStateData? seedPhraseStateData,
  }) {
    return KeychainStateData(
      seedPhraseStateData: seedPhraseStateData ?? this.seedPhraseStateData,
    );
  }

  @override
  List<Object?> get props => [
        seedPhraseStateData,
      ];
}
