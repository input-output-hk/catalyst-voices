import 'package:catalyst_voices/pages/registration/create_base_profile/stage/widgets/conditions_rich_text.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class ConditionsCheckbox extends StatelessWidget {
  const ConditionsCheckbox({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBaseProfileSelector<bool>(
      selector: (state) => state.conditionsAccepted,
      builder: (context, state) => _ConditionsCheckbox(accepted: state),
    );
  }
}

class _ConditionsCheckbox extends StatelessWidget {
  final bool accepted;

  const _ConditionsCheckbox({
    required this.accepted,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesCheckbox(
      key: const ValueKey('ConditionsCheckbox'),
      value: accepted,
      label: const ConditionsRichText(),
      onChanged: (value) {
        RegistrationCubit.of(context).baseProfile.updateConditions(accepted: value);
      },
    );
  }
}
