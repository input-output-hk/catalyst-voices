import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class RegistrationProgress extends Equatable {
  final BaseProfileProgress? baseProfileProgress;
  final KeychainProgress? keychainProgress;

  const RegistrationProgress({
    this.baseProfileProgress,
    this.keychainProgress,
  });

  bool get isEmpty => props.every((element) => element == null);

  RegistrationProgress copyWith({
    Optional<BaseProfileProgress>? baseProfileProgress,
    Optional<KeychainProgress>? keychainProgress,
  }) {
    return RegistrationProgress(
      baseProfileProgress: baseProfileProgress.dataOr(this.baseProfileProgress),
      keychainProgress: keychainProgress.dataOr(this.keychainProgress),
    );
  }

  @override
  List<Object?> get props => [
        baseProfileProgress,
        keychainProgress,
      ];
}

final class BaseProfileProgress extends Equatable {
  final String displayName;
  final String email;

  const BaseProfileProgress({
    required this.displayName,
    required this.email,
  });

  @override
  List<Object?> get props => [
        displayName,
        email,
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
