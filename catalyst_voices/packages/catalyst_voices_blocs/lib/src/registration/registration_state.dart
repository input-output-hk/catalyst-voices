import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';

/// Determines the state of registration flow.
/// It consists of 4 separate steps
///   - [GetStarted] which is first one.
///   - [FinishAccountCreation] is special step in case of partially created
///   account.
///   - [Recover] when want to start with existing one.
///   - [CreateNew] is entire flow in it self and has two distinguish sub-steps
///     - [CreateKeychain] where user is creating new keychain.
///     - [WalletLink] where user is linking Keychain with wallet.
sealed class RegistrationState extends Equatable {
  const RegistrationState();
}

/// User decides where to go here [CreateNew] or [Recover] route.
final class GetStarted extends RegistrationState {
  const GetStarted();

  @override
  List<Object?> get props => [];
}

/// When [CreateKeychain] is completed but [WalletLink] not.
final class FinishAccountCreation extends RegistrationState {
  const FinishAccountCreation();

  @override
  List<Object?> get props => [];
}

/// User enters existing seed phrase here.
final class Recover extends RegistrationState {
  const Recover();

  @override
  List<Object?> get props => [];
}

/// Encapsulates entire process of registration.
sealed class CreateNew extends RegistrationState {
  const CreateNew();
}

/// Building up information for creating new Keychain.
final class CreateKeychain extends CreateNew {
  final CreateKeychainStage stage;

  const CreateKeychain({
    this.stage = CreateKeychainStage.splash,
  });

  @override
  List<Object?> get props => [stage];
}

/// Linking existing keychain with wallet.
final class WalletLink extends CreateNew {
  final WalletLinkStage stage;

  const WalletLink({
    this.stage = WalletLinkStage.intro,
  });

  @override
  List<Object?> get props => [stage];
}
