import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class PasswordInput extends StatelessWidget {
  static const passwordInputKey = Key('PasswordInput');

  const PasswordInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: passwordInputKey,
          keyboardType: TextInputType.multiline,
          obscureText: true,
          textInputAction: TextInputAction.done,
          onChanged: (password) => _onPasswordChanged(context, password),
          decoration: InputDecoration(
            filled: true,
            errorMaxLines: 2,
            labelText: l10n.passwordLabelText,
            hintText: l10n.passwordHintText,
            errorText: l10n.passwordErrorText,
            border: const OutlineInputBorder(),
          ),
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        );
      },
    );
  }

  void _onPasswordChanged(BuildContext context, String password) {
    return context.read<LoginBloc>().add(
          LoginPasswordChanged(password),
        );
  }
}
