import 'dart:async';

import 'package:catalyst_voices/common/ext/text_editing_controller_ext.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_navigation.dart';
import 'package:catalyst_voices/pages/registration/widgets/unlock_password_form.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class UnlockPasswordPanel extends StatefulWidget {
  const UnlockPasswordPanel({
    super.key,
  });

  @override
  State<UnlockPasswordPanel> createState() => _UnlockPasswordPanelState();
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
    return BlocUnlockPasswordSelector<bool>(
      stateSelector: (state) => state.keychainStateData.unlockPasswordState,
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

class _BlocUnlockPasswordForm extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final ValueChanged<String>? onSubmitted;

  const _BlocUnlockPasswordForm({
    required this.passwordController,
    required this.confirmPasswordController,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return BlocUnlockPasswordSelector<
        ({
          bool showError,
          PasswordStrength passwordStrength,
          bool showPasswordStrength,
        })>(
      stateSelector: (state) => state.keychainStateData.unlockPasswordState,
      selector: (state) {
        return (
          showError: state.showPasswordMisMatch,
          passwordStrength: state.passwordStrength,
          showPasswordStrength: state.showPasswordStrength,
        );
      },
      builder: (context, state) {
        return UnlockPasswordForm(
          passwordController: passwordController,
          confirmPasswordController: confirmPasswordController,
          showError: state.showError,
          passwordStrength: state.passwordStrength,
          showPasswordStrength: state.showPasswordStrength,
          onSubmitted: onSubmitted,
        );
      },
    );
  }
}

class _UnlockPasswordPanelState extends State<UnlockPasswordPanel> {
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        const SizedBox(height: 12),
        Expanded(
          child: _BlocUnlockPasswordForm(
            passwordController: _passwordController,
            confirmPasswordController: _confirmPasswordController,
            onSubmitted: (_) => _createKeychain(),
          ),
        ),
        const SizedBox(height: 22),
        _BlocNavigation(
          onNextTap: _createKeychain,
          onBackTap: _clearPasswordAndGoBack,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    final unlockPasswordState = RegistrationCubit.of(context)
        .state
        .keychainStateData
        .unlockPasswordState;

    final password = unlockPasswordState.password.value;
    final confirmPassword = unlockPasswordState.confirmPassword.value;

    final passwordValue = TextEditingValueExt.collapsedAtEndOf(password);
    final confirmPasswordValue =
        TextEditingValueExt.collapsedAtEndOf(confirmPassword);

    _passwordController = TextEditingController.fromValue(passwordValue)
      ..addListener(_onPasswordChanged);

    _confirmPasswordController =
        TextEditingController.fromValue(confirmPasswordValue)
          ..addListener(_onConfirmPasswordChanged);
  }

  void _clearPasswordAndGoBack() {
    final registration = RegistrationCubit.of(context);

    registration.keychainCreation
      ..setPassword('')
      ..setConfirmPassword('');

    registration.previousStep();
  }

  void _createKeychain() {
    unawaited(RegistrationCubit.of(context).createKeychain());
  }

  void _onConfirmPasswordChanged() {
    final confirmPassword = _confirmPasswordController.text;

    RegistrationCubit.of(context)
        .keychainCreation
        .setConfirmPassword(confirmPassword);
  }

  void _onPasswordChanged() {
    final password = _passwordController.text;

    RegistrationCubit.of(context).keychainCreation.setPassword(password);
  }
}
