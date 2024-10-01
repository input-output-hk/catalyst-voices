import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class SeedPhraseState extends Equatable {
  final SeedPhrase? seedPhrase;
  final bool isStoredConfirmed;
  final bool isSeedPhraseChecked;

  const SeedPhraseState({
    this.seedPhrase,
    this.isStoredConfirmed = false,
    this.isSeedPhraseChecked = false,
  });

  SeedPhraseState copyWith({
    Optional<SeedPhrase>? seedPhrase,
    bool? isStoredConfirmed,
    bool? isSeedPhraseChecked,
  }) {
    return SeedPhraseState(
      seedPhrase: seedPhrase != null ? seedPhrase.data : this.seedPhrase,
      isStoredConfirmed: isStoredConfirmed ?? this.isStoredConfirmed,
      isSeedPhraseChecked: isSeedPhraseChecked ?? this.isSeedPhraseChecked,
    );
  }

  @override
  List<Object?> get props => [
        seedPhrase,
        isStoredConfirmed,
        isSeedPhraseChecked,
      ];
}
