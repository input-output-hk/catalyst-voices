import 'package:catalyst_voices/pages/registration/registration_stage_navigation.dart';
import 'package:catalyst_voices/widgets/indicators/voices_password_strength_indicator.dart';
import 'package:catalyst_voices/widgets/text_field/voices_password_text_field.dart';
import 'package:catalyst_voices/widgets/text_field/voices_text_field.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class UnlockPasswordPanel extends StatefulWidget {
  final UnlockPasswordState data;

  const UnlockPasswordPanel({
    super.key,
    required this.data,
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

    final password = widget.data.password;
    final confirmPassword = widget.data.confirmPassword;

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
        _ConfirmPasswordTextField(
          controller: _confirmPasswordController,
          showError: widget.data.showPasswordMisMatch,
          minimumLength: widget.data.minPasswordLength,
        ),
        const Spacer(),
        const SizedBox(height: 22),
        if (widget.data.showPasswordStrength)
          VoicesPasswordStrengthIndicator(
            passwordStrength: widget.data.passwordStrength,
          ),
        const SizedBox(height: 22),
        RegistrationBackNextNavigation(
          isNextEnabled: widget.data.isNextEnabled,
          onNextTap: _createKeychain,
          onBackTap: _clearPasswordAndGoBack,
        ),
      ],
    );
  }

  void _onPasswordChanged() {
    final password = _passwordController.text;
    RegistrationCubit.of(context).setPassword(password);
  }

  void _onConfirmPasswordChanged() {
    final confirmPassword = _confirmPasswordController.text;
    RegistrationCubit.of(context).setConfirmPassword(confirmPassword);
  }

  void _clearPasswordAndGoBack() {
    RegistrationCubit.of(context)
      ..setPassword('')
      ..setConfirmPassword('')
      ..previousStep();
  }

  Future<void> _createKeychain() async {
    final registrationCubit = RegistrationCubit.of(context);

    await registrationCubit.createKeychain();
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
