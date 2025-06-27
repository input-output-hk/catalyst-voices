import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class InstructionsNavigation extends StatelessWidget {
  const InstructionsNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBaseProfileSelector<bool>(
      selector: (state) => state.arAcknowledgementsAccepted,
      builder: (context, state) => _InstructionsNavigation(isEnabled: state),
    );
  }
}

class _InstructionsNavigation extends StatelessWidget {
  final bool isEnabled;

  const _InstructionsNavigation({
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      key: const Key('CreateBaseProfileNext'),
      onTap: isEnabled ? () => RegistrationCubit.of(context).nextStep() : null,
      child: Text(context.l10n.createProfileInstructionsNext),
    );
  }
}
