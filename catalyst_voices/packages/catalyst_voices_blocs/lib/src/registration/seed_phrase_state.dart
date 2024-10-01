import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class SeedPhraseState extends Equatable {
  final SeedPhrase? seedPhrase;
  final bool isStoredConfirmed;

  const SeedPhraseState({
    this.seedPhrase,
    this.isStoredConfirmed = false,
  });

  SeedPhraseState copyWith({
    Optional<SeedPhrase>? seedPhrase,
    bool? isStoredConfirmed,
  }) {
    return SeedPhraseState(
      seedPhrase: seedPhrase != null ? seedPhrase.data : this.seedPhrase,
      isStoredConfirmed: isStoredConfirmed ?? this.isStoredConfirmed,
    );
  }

  @override
  List<Object?> get props => [
        seedPhrase,
        isStoredConfirmed,
      ];
}
