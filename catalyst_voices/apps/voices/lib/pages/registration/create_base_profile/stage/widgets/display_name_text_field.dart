import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class DisplayNameTextField extends StatelessWidget {
  const DisplayNameTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBaseProfileSelector<Username>(
      selector: (state) => state.username,
      builder: (context, state) => _DisplayNameTextField(data: state),
    );
  }
}

class _DisplayNameTextField extends StatelessWidget {
  final Username data;

  const _DisplayNameTextField({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return VoicesUsernameTextField(
      key: const Key('DisplayNameTextField'),
      initialText: data.value,
      onChanged: (value) {
        RegistrationCubit.of(context).baseProfile.updateUsername(Username.dirty(value ?? ''));
      },
      onFieldSubmitted: null,
      decoration: VoicesTextFieldDecoration(
        labelText: l10n.createProfileSetupDisplayNameLabel.starred(),
        hintText: l10n.createProfileSetupDisplayNameHint,
        helperText: l10n.createProfileSetupDisplayNameHelper,
        errorText: data.displayError?.message(context),
      ),
      maxLength: Username.lengthRange.max,
    );
  }
}
