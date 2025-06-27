import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBaseProfileSelector<Email>(
      selector: (state) => state.email,
      builder: (context, state) => _EmailTextField(data: state),
    );
  }
}

class _EmailTextField extends StatelessWidget {
  final Email data;

  const _EmailTextField({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return VoicesEmailTextField(
      key: const Key('EmailTextField'),
      initialText: data.value,
      onChanged: (value) {
        RegistrationCubit.of(context).baseProfile.updateEmail(Email.dirty(value ?? ''));
      },
      onFieldSubmitted: (value) {
        final email = Email.dirty(value);
        final cubit = RegistrationCubit.of(context);

        cubit.baseProfile.updateEmail(email);

        if (cubit.state.baseProfileStateData.isBaseProfileDataValid) {
          cubit.nextStep();
        }
      },
      textInputAction: TextInputAction.done,
      decoration: VoicesTextFieldDecoration(
        labelText: l10n.createProfileSetupEmailLabel,
        subLabelText: context.l10n.createProfileSetupEmailSubLabel.inBrackets(),
        hintText: l10n.createProfileSetupEmailHint,
        helperText: l10n.createProfileSetupEmailHelper,
        errorText: data.displayError?.message(context),
      ),
      maxLength: Email.lengthRange.max,
    );
  }
}
