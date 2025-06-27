import 'package:catalyst_voices/pages/registration/create_base_profile/stage/widgets/registration_conditions_rich_text.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class RegistrationConditionsCheckbox extends StatelessWidget {
  const RegistrationConditionsCheckbox({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBaseProfileSelector<bool>(
      selector: (state) => state.conditionsAccepted,
      builder: (context, state) => _RegistrationConditionsCheckbox(accepted: state),
    );
  }
}

class _RegistrationConditionsCheckbox extends StatelessWidget {
  final bool accepted;

  const _RegistrationConditionsCheckbox({
    required this.accepted,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesCheckbox(
      key: const ValueKey('RegistrationConditionsCheckbox'),
      value: accepted,
      label: const RegistrationConditionsRichText(),
      onChanged: (value) {
        RegistrationCubit.of(context).baseProfile.updateConditions(accepted: value);
      },
    );
  }
}
