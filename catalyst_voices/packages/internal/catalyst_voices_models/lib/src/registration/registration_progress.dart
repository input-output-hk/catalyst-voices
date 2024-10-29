import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class RegistrationProgress extends Equatable {
  final KeychainProgress? keychainProgress;

  const RegistrationProgress({
    this.keychainProgress,
  });

  bool get isEmpty => props.every((element) => element == null);

  RegistrationProgress copyWith({
    Optional<KeychainProgress>? keychainProgress,
  }) {
    return RegistrationProgress(
      keychainProgress: keychainProgress.dataOr(this.keychainProgress),
    );
  }

  @override
  List<Object?> get props => [
        keychainProgress,
      ];
}

final class KeychainProgress extends Equatable {
  final SeedPhrase seedPhrase;
  final String password;

  const KeychainProgress({
    required this.seedPhrase,
    required this.password,
  });

  @override
  List<Object?> get props => [
        seedPhrase,
        password,
      ];
}
