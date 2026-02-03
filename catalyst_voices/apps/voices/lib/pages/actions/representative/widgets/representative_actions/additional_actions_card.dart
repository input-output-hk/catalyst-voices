import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/actions/representative/widgets/representative_actions/instruction_step_builder.dart';
import 'package:catalyst_voices/widgets/cards/voices_instructions_with_steps_card.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

/// Widget that displays additional representative actions (like stepping back)
/// as a card with instruction steps.
class AdditionalActionsCard extends StatelessWidget {
  const AdditionalActionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<
      RepresentativeActionCubit,
      RepresentativeActionState,
      StepBackRepresentativeActionStep?
    >(
      selector: (state) {
        return state.additionalStep;
      },
      builder: (context, stepDownAction) {
        if (stepDownAction == null) {
          return const SizedBox.shrink();
        }
        return _AdditionalActionsCard(step: stepDownAction);
      },
    );
  }
}

class _AdditionalActionsCard extends StatelessWidget {
  final StepBackRepresentativeActionStep step;

  const _AdditionalActionsCard({
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesInstructionsWithStepsCard(
      title: Text(
        context.l10n.additionalActions,
        style: context.textTheme.titleSmall,
      ),
      steps: [
        InstructionStepFactory.fromRepresentativeActionStep(
          step,
          context,
        ),
      ],
    );
  }
}
