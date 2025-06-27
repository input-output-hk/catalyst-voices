import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/registration/create_base_profile/stage/widgets/registration_conditions_checkbox.dart';
import 'package:catalyst_voices/pages/registration/create_base_profile/stage/widgets/tos_and_privacy_policy_checkbox.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class InstructionsAcknowledgements extends StatelessWidget {
  const InstructionsAcknowledgements({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TitleText(),
        SizedBox(height: 16),
        RegistrationConditionsCheckbox(),
        SizedBox(height: 12),
        TosAndPrivacyPolicyCheckbox(),
      ],
    );
  }
}

class _TitleText extends StatelessWidget {
  const _TitleText();

  @override
  Widget build(BuildContext context) {
    final textStyle = (context.textTheme.titleSmall ?? const TextStyle())
        .copyWith(color: context.colors.textOnPrimaryLevel1);

    return Text(
      context.l10n.createProfileAcknowledgementsTitle,
      style: textStyle,
    );
  }
}
