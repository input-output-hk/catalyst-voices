import 'package:catalyst_voices/pages/registration/create_keychain/bloc_unlock_password_builder.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_navigation.dart';
import 'package:catalyst_voices/widgets/indicators/voices_password_strength_indicator.dart';
import 'package:catalyst_voices/widgets/text_field/voices_password_text_field.dart';
import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class UnlockPasswordPanel extends StatefulWidget {
  const UnlockPasswordPanel({
    super.key,
  });

  @override
  State<UnlockPasswordPanel> createState() => _UnlockPasswordPanelState();
}

class _UnlockPasswordPanelState extends State<UnlockPasswordPanel> {
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();

    final unlockPasswordState = RegistrationCubit.of(context)
        .state
        .keychainStateData
        .unlockPasswordState;

    final password = unlockPasswordState.password;
    final confirmPassword = unlockPasswordState.confirmPassword;

    _passwordController = TextEditingController(text: password)
      ..addListener(_onPasswordChanged);
    _confirmPasswordController = TextEditingController(text: confirmPassword)
      ..addListener(_onConfirmPasswordChanged);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        const SizedBox(height: 12),
        _EnterPasswordTextField(
          controller: _passwordController,
        ),
        const SizedBox(height: 12),
        _BlocConfirmPasswordTextField(
          controller: _confirmPasswordController,
        ),
        const Spacer(),
        const SizedBox(height: 22),
        const _BlocPasswordStrength(),
        const SizedBox(height: 22),
        _BlocNavigation(
          onNextTap: _createKeychain,
          onBackTap: _clearPasswordAndGoBack,
        ),
      ],
    );
  }

  void _onPasswordChanged() {
    final password = _passwordController.text;

    RegistrationCubit.of(context).keychainCreation.setPassword(password);
  }

  void _onConfirmPasswordChanged() {
    final confirmPassword = _confirmPasswordController.text;

    RegistrationCubit.of(context)
        .keychainCreation
        .setConfirmPassword(confirmPassword);
  }

  void _clearPasswordAndGoBack() {
    final registration = RegistrationCubit.of(context);

    registration.keychainCreation
      ..setPassword('')
      ..setConfirmPassword('');

    registration.previousStep();
  }

  Future<void> _createKeychain() async {
    final registrationCubit = RegistrationCubit.of(context);

    await registrationCubit.keychainCreation.createKeychain();

    registrationCubit.nextStep();
  }
}

class _EnterPasswordTextField extends StatelessWidget {
  final TextEditingController controller;

  const _EnterPasswordTextField({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesPasswordTextField(
      controller: controller,
      textInputAction: TextInputAction.next,
      decoration: VoicesTextFieldDecoration(
        labelText: context.l10n.enterPassword,
      ),
    );
  }
}

class _BlocConfirmPasswordTextField extends StatelessWidget {
  final TextEditingController controller;

  const _BlocConfirmPasswordTextField({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return BlocUnlockPasswordBuilder<({bool showError, int minimumLength})>(
      selector: (state) => (
        showError: state.showPasswordMisMatch,
        minimumLength: state.minPasswordLength,
      ),
      builder: (context, state) {
        return _ConfirmPasswordTextField(
          controller: controller,
          showError: state.showError,
          minimumLength: state.minimumLength,
        );
      },
    );
  }
}

class _ConfirmPasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool showError;
  final int minimumLength;

  const _ConfirmPasswordTextField({
    required this.controller,
    this.showError = false,
    required this.minimumLength,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesPasswordTextField(
      controller: controller,
      decoration: VoicesTextFieldDecoration(
        labelText: context.l10n.confirmPassword,
        helperText: context.l10n.xCharactersMinimum(minimumLength),
        errorText: showError ? context.l10n.passwordDoNotMatch : null,
      ),
    );
  }
}

class _BlocPasswordStrength extends StatelessWidget {
  const _BlocPasswordStrength();

  @override
  Widget build(BuildContext context) {
    return BlocUnlockPasswordBuilder<({bool show, PasswordStrength strength})>(
      selector: (state) => (
        show: state.showPasswordStrength,
        strength: state.passwordStrength,
      ),
      builder: (context, state) {
        return Offstage(
          offstage: !state.show,
          child: VoicesPasswordStrengthIndicator(
            passwordStrength: state.strength,
          ),
        );
      },
    );
  }
}

class _BlocNavigation extends StatelessWidget {
  final VoidCallback onNextTap;
  final VoidCallback onBackTap;

  const _BlocNavigation({
    required this.onNextTap,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocUnlockPasswordBuilder<bool>(
      selector: (state) => state.isNextEnabled,
      builder: (context, state) {
        return RegistrationBackNextNavigation(
          isNextEnabled: state,
          onNextTap: onNextTap,
          onBackTap: onBackTap,
        );
      },
    );
  }
}
