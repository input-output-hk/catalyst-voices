import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final class SectionStepState extends Equatable {
  final bool isSelected;

  const SectionStepState({
    required this.isSelected,
  });

  @override
  List<Object?> get props => [
        isSelected,
      ];
}

class SectionStepStateBuilder extends StatelessWidget {
  final SectionStepId id;
  final ValueWidgetBuilder<SectionStepState> builder;
  final Widget? child;

  const SectionStepStateBuilder({
    super.key,
    required this.id,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final controller = SectionsControllerScope.of(context);

    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) {
        final isSelected = value.activeStepId == id;

        final state = SectionStepState(
          isSelected: isSelected,
        );

        return builder(context, state, child);
      },
      child: child,
    );
  }
}
