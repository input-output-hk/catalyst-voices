import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/avatars/voices_avatar.dart';
import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices/widgets/containers/grey_out_container.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class VoicesInstructionsWithStepsCard extends StatelessWidget {
  final Widget title;
  final List<InstructionStep> steps;

  const VoicesInstructionsWithStepsCard({
    super.key,
    required this.title,
    this.steps = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.colors.elevationsOnSurfaceNeutralLv1Grey,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Column(
        spacing: 8,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          title,
          ...steps.mapIndexed(
            (index, element) => _StepItem(step: element, index: index),
          ),
        ],
      ),
    );
  }
}

class _InstructionStepItem extends StatelessWidget {
  final Widget? icon;
  final Widget child;

  const _InstructionStepItem({
    this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.elevationsOnSurfaceNeutralLv1White,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          child,
          ?icon,
        ],
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final int index;
  final InstructionStep step;

  const _StepItem({
    required this.index,
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    return GreyOutContainer(
      greyOut: !step.isActive,
      child: AffixDecorator(
        prefix: Padding(
          padding: const EdgeInsets.all(12),
          child: VoicesAvatar(
            icon:
                step.prefix ??
                Text(
                  '${index + 1}',
                  style: context.textTheme.titleLarge?.copyWith(
                    color: context.colors.textOnPrimaryWhite,
                  ),
                ),
            radius: 22,
            padding: const EdgeInsets.all(2),
            backgroundColor: step.prefixBackgroundColor ?? context.colorScheme.primary,
          ),
        ),
        gap: 4,
        child: _InstructionStepItem(icon: step.suffix, child: step.child),
      ),
    );
  }
}
