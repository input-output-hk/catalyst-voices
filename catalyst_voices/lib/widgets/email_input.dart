import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class EmailInput extends StatelessWidget {
  static const emailInputKey = Key('EmailInput');

  const EmailInput({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: emailInputKey,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          onChanged: (email) => context.read<LoginBloc>().add(
                LoginEmailChanged(email),
              ),
          decoration: InputDecoration(
            filled: true,
            labelText: l10n.emailLabelText,
            hintText: l10n.emailHintText,
            errorText: l10n.emailErrorText,
            border: const OutlineInputBorder(),
          ),
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        );
      },
    );
  }
}
