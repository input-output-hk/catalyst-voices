import 'package:catalyst_voices/pages/login/login.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class LoginPage extends StatelessWidget {
  static const loginPage = Key('LoginInPage');

  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      key: loginPage,
      create: (context) {
        return LoginBloc(
          authenticationRepository:
              RepositoryProvider.of<AuthenticationRepository>(
            context,
          ),
        );
      },
      child: const LoginForm(),
    );
  }
}
