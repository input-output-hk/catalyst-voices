import 'package:catalyst_voices/pages/registration/create_base_profile/stage/widgets/drep_approval_contingency_rich_text.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

class DrepApprovalContingencyCheckbox extends StatelessWidget {
  const DrepApprovalContingencyCheckbox({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBaseProfileSelector<bool>(
      selector: (state) => state.drepApprovalContingencyAccepted,
      builder: (context, state) => _DrepApprovalContingencyCheckbox(accepted: state),
    );
  }
}

class _DrepApprovalContingencyCheckbox extends StatelessWidget {
  final bool accepted;

  const _DrepApprovalContingencyCheckbox({
    required this.accepted,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesCheckbox(
      value: accepted,
      label: const DrepApprovalContingencyRichText(),
      onChanged: (value) {
        RegistrationCubit.of(context).baseProfile.updateDrepApprovalContingency(accepted: value);
      },
      semanticsIdentifier: 'drepApprovalContingencyCheckbox',
    );
  }
}
