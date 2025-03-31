import 'package:catalyst_voices/common/ext/text_editing_controller_ext.dart';
import 'package:catalyst_voices/pages/registration/widgets/registration_stage_navigation.dart';
import 'package:catalyst_voices/pages/registration/widgets/unlock_password_form.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class UnlockPasswordPanel extends StatefulWidget {
  const UnlockPasswordPanel({super.key});

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
        .recoverStateData
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

    RegistrationCubit.of(context).recover.setPassword(password);
  }

  void _onConfirmPasswordChanged() {
    final confirmPassword = _confirmPasswordController.text;

    RegistrationCubit.of(context).recover.setConfirmPassword(confirmPassword);
  }

  Future<void> _createKeychain() async {
    final cubit = RegistrationCubit.of(context);

    final success = await cubit.recover.setupKeychain();

    if (success) {
      cubit.nextStep();
    }
  }

  void _clearPasswordAndGoBack() {
    final registration = RegistrationCubit.of(context);

    registration.recover
      ..setPassword('')
      ..setConfirmPassword('');

    registration.previousStep();
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
    return BlocUnlockPasswordSelector<
        ({
          bool showError,
          PasswordStrength passwordStrength,
          bool showPasswordStrength,
        })>(
      stateSelector: (state) => state.recoverStateData.unlockPasswordState,
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
    return BlocUnlockPasswordSelector<bool>(
      stateSelector: (state) => state.recoverStateData.unlockPasswordState,
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
