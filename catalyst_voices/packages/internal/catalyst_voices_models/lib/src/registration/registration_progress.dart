import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class BaseProfileProgress extends Equatable {
  final String username;
  final String email;

  const BaseProfileProgress({
    required this.username,
    required this.email,
  });

  @override
  List<Object?> get props => [
        username,
        email,
      ];
}

final class KeychainProgress extends Equatable {
  final String keychainId;
  final SeedPhrase seedPhrase;
  final String password;

  const KeychainProgress({
    required this.keychainId,
    required this.seedPhrase,
    required this.password,
  });

  @override
  List<Object?> get props => [
        keychainId,
        seedPhrase,
        password,
      ];
}

final class RegistrationProgress extends Equatable {
  final BaseProfileProgress? baseProfileProgress;
  final KeychainProgress? keychainProgress;

  const RegistrationProgress({
    this.baseProfileProgress,
    this.keychainProgress,
  });

  bool get isEmpty => props.every((element) => element == null);

  @override
  List<Object?> get props => [
        baseProfileProgress,
        keychainProgress,
      ];

  RegistrationProgress copyWith({
    Optional<BaseProfileProgress>? baseProfileProgress,
    Optional<KeychainProgress>? keychainProgress,
  }) {
    return RegistrationProgress(
      baseProfileProgress: baseProfileProgress.dataOr(this.baseProfileProgress),
      keychainProgress: keychainProgress.dataOr(this.keychainProgress),
    );
  }
}
