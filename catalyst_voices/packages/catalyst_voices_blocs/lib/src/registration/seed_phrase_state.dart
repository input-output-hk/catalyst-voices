import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class SeedPhraseState extends Equatable {
  final SeedPhrase? seedPhrase;
  final bool isStoredConfirmed;
  final bool isCheckConfirmed;

  const SeedPhraseState({
    this.seedPhrase,
    this.isStoredConfirmed = false,
    this.isCheckConfirmed = false,
  });

  SeedPhraseState copyWith({
    Optional<SeedPhrase>? seedPhrase,
    bool? isStoredConfirmed,
    bool? isCheckConfirmed,
  }) {
    return SeedPhraseState(
      seedPhrase: seedPhrase != null ? seedPhrase.data : this.seedPhrase,
      isStoredConfirmed: isStoredConfirmed ?? this.isStoredConfirmed,
      isCheckConfirmed: isCheckConfirmed ?? this.isCheckConfirmed,
    );
  }

  @override
  List<Object?> get props => [
        seedPhrase,
        isStoredConfirmed,
        isCheckConfirmed,
      ];
}
