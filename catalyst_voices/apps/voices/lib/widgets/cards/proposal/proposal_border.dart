import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class ProposalBorder extends StatelessWidget {
  final ProposalPublish publishStage;
  final WidgetStatesController statesController;
  final Widget child;

  const ProposalBorder({
    super.key,
    required this.publishStage,
    required this.statesController,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final color = _Color(
      publishStage: publishStage,
      colors: context.colors,
      colorScheme: context.colorScheme,
    );
    final width = _Width();

    return ValueListenableBuilder(
      valueListenable: statesController,
      builder: (context, value, child) {
        return DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.resolve(value),
              width: width.resolve(value),
            ),
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}

final class _Color extends WidgetStateProperty<Color> {
  final ProposalPublish publishStage;
  final VoicesColorScheme colors;
  final ColorScheme colorScheme;

  _Color({
    required this.publishStage,
    required this.colors,
    required this.colorScheme,
  });

  @override
  Color resolve(Set<WidgetState> states) {
    if (const [WidgetState.hovered, WidgetState.focused].any(states.contains)) {
      return switch (publishStage) {
        ProposalPublish.localDraft ||
        ProposalPublish.publishedDraft =>
          colorScheme.secondary,
        ProposalPublish.submittedProposal => colorScheme.primary,
      };
    }

    return colors.elevationsOnSurfaceNeutralLv1White;
  }
}

final class _Width extends WidgetStateProperty<double> {
  _Width();

  @override
  double resolve(Set<WidgetState> states) {
    if (const [WidgetState.pressed, WidgetState.focused].any(states.contains)) {
      return 3;
    }

    if (const [WidgetState.hovered].any(states.contains)) {
      return 2;
    }

    return 0;
  }
}
