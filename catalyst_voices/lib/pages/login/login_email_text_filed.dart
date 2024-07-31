import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class LoginEmailTextFiled extends StatelessWidget {
  static const emailInputKey = Key('EmailInput');

  const LoginEmailTextFiled({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return VoicesEmailTextField(
          key: emailInputKey,
          onChanged: (email) => _onEmailChanged(context, email),
        );
      },
    );
  }

  void _onEmailChanged(BuildContext context, String email) {
    context.read<LoginBloc>().add(LoginEmailChanged(email));
  }
}
