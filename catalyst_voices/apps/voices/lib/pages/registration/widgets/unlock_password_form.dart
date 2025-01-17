import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class UnlockPasswordForm extends StatelessWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool showError;
  final PasswordStrength passwordStrength;
  final bool showPasswordStrength;

  const UnlockPasswordForm({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
    this.showError = false,
    this.passwordStrength = PasswordStrength.weak,
    this.showPasswordStrength = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _UnlockPasswordTextField(
          controller: passwordController,
        ),
        const SizedBox(height: 12),
        _ConfirmUnlockPasswordTextField(
          controller: confirmPasswordController,
          showError: showError,
          minimumLength: PasswordStrength.minimumLength,
        ),
        const Spacer(),
        const SizedBox(height: 22),
        _PasswordStrength(
          strength: passwordStrength,
          visible: showPasswordStrength,
        ),
      ],
    );
  }
}

class _UnlockPasswordTextField extends StatelessWidget {
  final TextEditingController controller;

  const _UnlockPasswordTextField({
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesPasswordTextField(
      key: const Key('PasswordInputField'),
      controller: controller,
      textInputAction: TextInputAction.next,
      decoration: VoicesTextFieldDecoration(
        labelText: context.l10n.enterPassword,
      ),
    );
  }
}

class _ConfirmUnlockPasswordTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool showError;
  final int minimumLength;

  const _ConfirmUnlockPasswordTextField({
    required this.controller,
    this.showError = false,
    required this.minimumLength,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesPasswordTextField(
      key: const Key('PasswordConfirmInputField'),
      controller: controller,
      decoration: VoicesTextFieldDecoration(
        labelText: context.l10n.confirmPassword,
        helperText: context.l10n.xCharactersMinimum(minimumLength),
        errorText: showError ? context.l10n.passwordDoNotMatch : null,
      ),
    );
  }
}

class _PasswordStrength extends StatelessWidget {
  final PasswordStrength strength;
  final bool visible;

  const _PasswordStrength({
    this.strength = PasswordStrength.weak,
    this.visible = false,
  });

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !visible,
      child: VoicesPasswordStrengthIndicator(
        passwordStrength: strength,
      ),
    );
  }
}
