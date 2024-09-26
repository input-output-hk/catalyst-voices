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

  double? get progress => null;

  @override
  List<Object?> get props => [];
}

/// User decides where to go here [CreateNew] or [Recover] route.
final class GetStarted extends RegistrationState {
  const GetStarted();
}

/// When [CreateKeychain] is completed but [WalletLink] not.
final class FinishAccountCreation extends RegistrationState {
  const FinishAccountCreation();
}

/// User enters existing seed phrase here.
final class Recover extends RegistrationState {
  const Recover();
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
  double get progress {
    final current = CreateKeychainStage.values.indexOf(stage);
    final total = CreateKeychainStage.values.length;
    return current / total;
  }

  @override
  List<Object?> get props => super.props + [stage];
}

/// Linking existing keychain with wallet.
final class WalletLink extends CreateNew {
  final WalletLinkStage stage;

  const WalletLink({
    this.stage = WalletLinkStage.intro,
  });

  @override
  double get progress {
    final current = WalletLinkStage.values.indexOf(stage);
    final total = WalletLinkStage.values.length;
    return current / total;
  }

  @override
  List<Object?> get props => super.props + [stage];
}
