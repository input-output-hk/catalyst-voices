import 'package:catalyst_voices/pages/registration/create_base_profile/stage/widgets/tos_and_privacy_policy_rich_text.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class TosAndPrivacyPolicyCheckbox extends StatelessWidget {
  const TosAndPrivacyPolicyCheckbox({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBaseProfileSelector<bool>(
      selector: (state) => state.tosAndPrivacyPolicyAccepted,
      builder: (context, state) => _TosAndPrivacyPolicyCheckbox(accepted: state),
    );
  }
}

class _TosAndPrivacyPolicyCheckbox extends StatelessWidget {
  final bool accepted;

  const _TosAndPrivacyPolicyCheckbox({
    required this.accepted,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesCheckbox(
      value: accepted,
      label: const TosAndPrivacyPolicyRichText(),
      onChanged: (value) {
        RegistrationCubit.of(context).baseProfile.updateTosAndPrivacyPolicy(accepted: value);
      },
    );
  }
}
