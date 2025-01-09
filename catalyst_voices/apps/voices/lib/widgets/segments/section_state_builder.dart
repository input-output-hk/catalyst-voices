import 'package:catalyst_voices/widgets/segments/segments_controller.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

final class SectionState extends Equatable {
  final bool isSelected;

  const SectionState({
    required this.isSelected,
  });

  @override
  List<Object?> get props => [
        isSelected,
      ];
}

class SectionStateBuilder extends StatelessWidget {
  final NodeId id;
  final ValueWidgetBuilder<SectionState> builder;
  final Widget? child;

  const SectionStateBuilder({
    super.key,
    required this.id,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final controller = SegmentsControllerScope.of(context);

    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, child) {
        final isSelected = value.activeSectionId == id;

        final state = SectionState(
          isSelected: isSelected,
        );

        return builder(context, state, child);
      },
      child: child,
    );
  }
}
