import 'package:catalyst_voices/pages/login/login.dart';
import 'package:catalyst_voices/pages/login/login_email_text_filed.dart';
import 'package:catalyst_voices/pages/login/login_password_text_field.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

final class LoginForm extends StatelessWidget {
  static const loginFormKey = Key('LoginForm');
  static const loginErrorSnackbarKey = Key('LoginErrorSnackbar');

  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status.isFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  key: loginErrorSnackbarKey,
                  content: Text(l10n.loginScreenErrorMessage),
                ),
              );
          }
        },
        child: Center(
          child: SizedBox(
            height: 460,
            width: 480,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        l10n.loginTitleText,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const LoginEmailTextFiled(),
                    const SizedBox(height: 20),
                    const LoginPasswordTextField(),
                    const SizedBox(height: 20),
                    const SizedBox(
                      width: double.infinity,
                      child: LoginInButton(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
