import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/toggles/voices_checkbox.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ReceiveEmailsCheckbox extends StatelessWidget {
  const ReceiveEmailsCheckbox({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBaseProfileSelector<ReceiveEmails>(
      selector: (state) => state.receiveEmails,
      builder: (context, state) => _ReceiveEmailsCheckbox(data: state),
    );
  }
}

class _ReceiveEmailsCheckbox extends StatelessWidget {
  final ReceiveEmails data;

  const _ReceiveEmailsCheckbox({
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesCheckbox(
      value: data.isAccepted,
      label: _ReceiveEmailsCheckboxLabelText(isEnabled: data.isEnabled),
      onChanged: (value) {
        RegistrationCubit.of(context).baseProfile.updateReceiveEmails(isAccepted: value);
      },
      isEnabled: data.isEnabled,
    );
  }
}

class _ReceiveEmailsCheckboxLabelText extends StatelessWidget {
  final bool isEnabled;

  const _ReceiveEmailsCheckboxLabelText({
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final color = isEnabled ? context.colors.textOnPrimaryLevel0 : context.colors.textDisabled;

    return Text(
      context.l10n.createProfileSetupReceiveEmails,
      style: context.textTheme.bodyMedium?.copyWith(color: color),
    );
  }
}
