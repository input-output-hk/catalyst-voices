import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/actions/representative/widgets/representative_actions/instruction_step_builder.dart';
import 'package:catalyst_voices/widgets/cards/voices_instructions_with_steps_card.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

/// Widget that displays the main representative actions as a card with instruction steps.
class RepresentativeActionsCard extends StatelessWidget {
  const RepresentativeActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      RepresentativeActionCubit,
      RepresentativeActionState,
      IterableData<List<RepresentativeActionStep>>
    >(
      selector: (state) {
        return IterableData(state.representativeActions);
      },
      builder: (context, data) {
        final steps = data.value;
        return Offstage(
          offstage: steps.isEmpty,
          child: _RepresentativeActionsCard(
            steps: steps,
          ),
        );
      },
    );
  }
}

class _RepresentativeActionsCard extends StatelessWidget {
  final List<RepresentativeActionStep> steps;

  const _RepresentativeActionsCard({
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesInstructionsWithStepsCard(
      title: Text(
        context.l10n.representativeActions,
        style: context.textTheme.titleSmall,
      ),
      steps: steps
          .map(
            (step) => InstructionStepFactory.fromRepresentativeActionStep(
              step,
              context,
            ),
          )
          .toList(),
    );
  }
}
