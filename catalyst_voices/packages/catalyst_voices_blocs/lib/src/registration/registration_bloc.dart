import 'package:catalyst_voices_blocs/src/registration/controllers/keychain_creation_controller.dart';
import 'package:catalyst_voices_blocs/src/registration/controllers/wallet_link_controller.dart';
import 'package:catalyst_voices_blocs/src/registration/registration_event.dart';
import 'package:catalyst_voices_blocs/src/registration/registration_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Manages the registration state.
final class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState>
    implements KeychainCreationController, WalletLinkController {
  final RegistrationKeychainCreationController _keychainCreationController;
  final RegistrationWalletLinkController _walletLinkController;

  RegistrationBloc()
      : _keychainCreationController = RegistrationKeychainCreationController(),
        _walletLinkController = RegistrationWalletLinkController(),
        super(const GetStarted()) {
    on<RegistrationEvent>(_handleRegistrationEvent);
  }

  /// Returns [RegistrationBloc] if found in widget tree. Does not add
  /// rebuild dependency when called.
  static RegistrationBloc of(BuildContext context) {
    return context.read<RegistrationBloc>();
  }

  /// Returns [RegistrationBloc] if found in widget tree. Adds rebuild
  /// dependency when called so you can not call it in initState.
  static RegistrationBloc watch(BuildContext context) {
    return context.watch<RegistrationBloc>();
  }

  void _handleRegistrationEvent(
    RegistrationEvent event,
    Emitter<RegistrationState> emit,
  ) {
    final nextState = switch (event) {
      CreateAccountTypeEvent(:final type) => _createAccountNextStep(type),
      NextStepEvent() => _nextStep(),
      PreviousStepEvent() => _previousStep(),
    };

    emit(nextState);
  }

  RegistrationState _createAccountNextStep(CreateAccountType type) {
    return switch (type) {
      CreateAccountType.createNew => const CreateKeychain(),
      CreateAccountType.recover => const Recover(),
    };
  }

  RegistrationState _nextStep() {
    /// Nested function. Responsible only for keychain steps logic.
    RegistrationState keychainNextStep() {
      final nextStep = _keychainCreationController.nextStep();

      return nextStep ?? const FinishAccountCreation();
    }

    /// Nested function. Responsible only for wallet link steps logic.
    RegistrationState walletLinkNextStep() {
      final nextStep = _walletLinkController.nextStep();

      return nextStep ?? state;
    }

    return switch (state) {
      GetStarted() => throw StateError(
          'GetStarted has two routes that may go to. '
          'NextStep is not valid here.',
        ),
      FinishAccountCreation() => throw UnimplementedError(),
      Recover() => throw UnimplementedError(),
      CreateKeychain() => keychainNextStep(),
      WalletLink() => walletLinkNextStep(),
    };
  }

  RegistrationState _previousStep() {
    /// Nested function. Responsible only for keychain steps logic.
    RegistrationState keychainPreviousStep() {
      final previousStep = _keychainCreationController.previousStep();

      return previousStep ?? const GetStarted();
    }

    /// Nested function. Responsible only for wallet link steps logic.
    RegistrationState walletLinkPreviousStep() {
      final previousStep = _walletLinkController.previousStep();

      return previousStep ?? const FinishAccountCreation();
    }

    return switch (state) {
      GetStarted() => throw StateError('GetStarted is initial step.'),
      FinishAccountCreation() => throw UnimplementedError(),
      Recover() => throw UnimplementedError(),
      CreateKeychain() => keychainPreviousStep(),
      WalletLink() => walletLinkPreviousStep(),
    };
  }

  @override
  ValueListenable<AvailableCardanoWallets> get cardanoWallets =>
      _walletLinkController.cardanoWallets;

  @override
  Future<void> refreshCardanoWallets() async =>
      _walletLinkController.refreshCardanoWallets();
}
