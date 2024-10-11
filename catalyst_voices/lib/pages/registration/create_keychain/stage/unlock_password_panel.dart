import 'package:catalyst_voices/pages/registration/bloc_unlock_password_builder.dart';
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

    final password = unlockPasswordState.password.value;
    final confirmPassword = unlockPasswordState.confirmPassword.value;

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
        Expanded(
          child: _BlocUnlockPasswordForm(
            passwordController: _passwordController,
            confirmPasswordController: _confirmPasswordController,
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

    final isSuccess = await registrationCubit.keychainCreation.createKeychain();

    if (isSuccess) {
      registrationCubit.nextStep();
    }
  }
}

class _BlocUnlockPasswordForm extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const _BlocUnlockPasswordForm({
    required this.passwordController,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocUnlockPasswordBuilder<
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
