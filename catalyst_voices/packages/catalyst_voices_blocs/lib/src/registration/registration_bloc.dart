import 'package:catalyst_voices_blocs/src/registration/controllers/keychain_creation_controller.dart';
import 'package:catalyst_voices_blocs/src/registration/controllers/wallet_link_controller.dart';
import 'package:catalyst_voices_blocs/src/registration/registration_event.dart';
import 'package:catalyst_voices_blocs/src/registration/registration_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Manages the registration state.
final class RegistrationBloc
    extends Bloc<RegistrationEvent, RegistrationState> {
  final KeychainCreationController _keychainCreationController;
  final WalletLinkController _walletLinkController;

  RegistrationBloc()
      : _keychainCreationController = KeychainCreationController(),
        _walletLinkController = WalletLinkController(),
        super(const GetStarted()) {
    _keychainCreationController.addListener(_onKeychainControllerChanged);
    _walletLinkController.addListener(_onWalletLinkControllerChanged);

    on<RegistrationNavigationEvent>(_handleNavigationEvent);
    on<KeychainCreationEvent>(_handleKeychainCreationEvent);
    on<WalletLinkEvent>(_handleWalletLinkingEvent);
    on<RebuildStateEvent>(_handleRebuildStateEvent);
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

  void _handleRebuildStateEvent(
    RebuildStateEvent event,
    Emitter<RegistrationState> emit,
  ) {
    emit(_buildState());
  }

  void _handleKeychainCreationEvent(
    KeychainCreationEvent event,
    Emitter<RegistrationState> emit,
  ) {
    _keychainCreationController.handleEvent(event);
    emit(_buildState());
  }

  void _handleWalletLinkingEvent(
    WalletLinkEvent event,
    Emitter<RegistrationState> emit,
  ) {
    _walletLinkController.handleEvent(event);
    emit(_buildState());
  }

  void _handleNavigationEvent(
    RegistrationNavigationEvent event,
    Emitter<RegistrationState> emit,
  ) {
    RegistrationStep? buildAccountNextStep(CreateAccountType type) {
      return switch (type) {
        CreateAccountType.createNew =>
          _nextStep(from: const CreateKeychainStep()),
        CreateAccountType.recover => _nextStep(from: const RecoverStep()),
      };
    }

    final newStep = switch (event) {
      CreateAccountTypeEvent(:final type) => buildAccountNextStep(type),
      NextStepEvent() => _nextStep(),
      PreviousStepEvent() => _previousStep(),
    };

    if (newStep == null) {
      return;
    }

    emit(_buildState(step: newStep));
  }

  RegistrationStep? _nextStep({RegistrationStep? from}) {
    final step = from ?? state.step;

    RegistrationStep nextKeychainStep(CreateKeychainStage stage) {
      final nextStep = _keychainCreationController.nextStep(stage);

      // if there is no next step from keychain creation go to finish account.
      return nextStep ?? const FinishAccountCreationStep();
    }

    RegistrationStep nextWalletLinkStep(WalletLinkStage stage) {
      final nextStep = _walletLinkController.nextStep(stage);

      // if there is no next step from wallet link go to account completed.
      return nextStep ?? const AccountCompletedStep();
    }

    return switch (step) {
      GetStartedStep() => null,
      FinishAccountCreationStep() => nextWalletLinkStep(WalletLinkStage.intro),
      RecoverStep() => throw UnimplementedError(),
      CreateKeychainStep(:final stage) => nextKeychainStep(stage),
      WalletLinkStep(:final stage) => nextWalletLinkStep(stage),
      AccountCompletedStep() => null,
    };
  }

  RegistrationStep? _previousStep({RegistrationStep? from}) {
    final step = from ?? state.step;

    /// Nested function. Responsible only for keychain steps logic.
    RegistrationStep previousKeychainStep(CreateKeychainStage stage) {
      final previousStep = _keychainCreationController.previousStep(stage);

      // if is at first step of keychain creation go to get started.
      return previousStep ?? const GetStartedStep();
    }

    /// Nested function. Responsible only for wallet link steps logic.
    RegistrationStep previousWalletLinkStep(WalletLinkStage stage) {
      final previousStep = _walletLinkController.previousStep(stage);

      // if is at first step of wallet link go to finish account.
      return previousStep ?? const FinishAccountCreationStep();
    }

    return switch (step) {
      GetStartedStep() => null,
      FinishAccountCreationStep() => null,
      RecoverStep() => throw UnimplementedError(),
      CreateKeychainStep(:final stage) => previousKeychainStep(stage),
      WalletLinkStep(:final stage) => previousWalletLinkStep(stage),
      AccountCompletedStep() => null,
    };
  }

  void _onKeychainControllerChanged() {
    add(const RebuildStateEvent());
  }

  void _onWalletLinkControllerChanged() {
    add(const RebuildStateEvent());
  }

  RegistrationState _buildState({
    RegistrationStep? step,
  }) {
    step ??= state.step;

    return switch (step) {
      GetStartedStep() => const GetStarted(),
      FinishAccountCreationStep() => const FinishAccountCreation(),
      RecoverStep() => const Recover(),
      CreateKeychainStep(:final stage) =>
        _keychainCreationController.buildState(stage),
      WalletLinkStep(:final stage) => _walletLinkController.buildState(stage),
      AccountCompletedStep() => const AccountCompleted(),
    };
  }
}
