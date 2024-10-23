import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

final class RegistrationProgress extends Equatable {
  final SeedPhrase? seedPhrase;
  final String? password;

  const RegistrationProgress({
    this.seedPhrase,
    this.password,
  });

  bool get isEmpty => props.every((element) => element == null);

  RegistrationProgress copyWith({
    Optional<SeedPhrase>? seedPhrase,
    Optional<String>? password,
  }) {
    return RegistrationProgress(
      seedPhrase: seedPhrase.dataOr(this.seedPhrase),
      password: password.dataOr(this.password),
    );
  }

  @override
  List<Object?> get props => [
        seedPhrase,
        password,
      ];
}
