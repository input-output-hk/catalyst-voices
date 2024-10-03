import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class LoginPasswordTextField extends StatelessWidget {
  static const passwordInputKey = Key('PasswordInput');

  const LoginPasswordTextField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        final l10n = context.l10n;

        return VoicesPasswordTextField(
          key: passwordInputKey,
          onChanged: (password) => _onPasswordChanged(context, password),
          decoration: VoicesTextFieldDecoration(
            errorMaxLines: 2,
            labelText: l10n.passwordLabelText,
            hintText: l10n.passwordHintText,
            errorText: l10n.passwordErrorText,
          ),
        );
      },
    );
  }

  void _onPasswordChanged(BuildContext context, String password) {
    context.read<LoginBloc>().add(LoginPasswordChanged(password));
  }
}
