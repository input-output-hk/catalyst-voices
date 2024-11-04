import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

final class LoginInButton extends StatelessWidget {
  static const loginButtonKey = Key('LoginInButton');

  const LoginInButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isInProgress
            ? const Center(child: CircularProgressIndicator())
            : FloatingActionButton.extended(
                heroTag: UniqueKey(),
                label: Text(
                  l10n.loginButtonText,
                ),
                onPressed: () {
                  if (state.isValid) {
                    context.read<LoginBloc>().add(const LoginSubmitted());
                  }
                },
              );
      },
    );
  }
}
