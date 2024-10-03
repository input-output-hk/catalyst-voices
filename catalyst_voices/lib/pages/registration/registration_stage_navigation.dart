import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class RegistrationBackNextNavigation extends StatelessWidget {
  final bool isBackEnabled;
  final bool isNextEnabled;
  final VoidCallback? onNextTap;
  final VoidCallback? onBackTap;

  const RegistrationBackNextNavigation({
    super.key,
    this.isBackEnabled = true,
    this.isNextEnabled = true,
    this.onNextTap,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return RegistrationStageNavigation(
      axis: Axis.horizontal,
      spacing: 10,
      children: [
        VoicesBackButton(
          onTap: isBackEnabled
              ? onBackTap ?? () => RegistrationCubit.of(context).previousStep()
              : null,
        ),
        VoicesNextButton(
          onTap: isNextEnabled
              ? onNextTap ?? () => RegistrationCubit.of(context).nextStep()
              : null,
        ),
      ],
    );
  }
}

class RegistrationStageNavigation extends StatelessWidget {
  final Axis axis;
  final double spacing;
  final List<Widget> children;

  const RegistrationStageNavigation({
    super.key,
    required this.axis,
    required this.spacing,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    switch (axis) {
      case Axis.horizontal:
        return Row(
          children: children
              .map<Widget>((e) => Expanded(child: e))
              .separatedBy(SizedBox(width: spacing))
              .toList(),
        );
      case Axis.vertical:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: children.separatedBy(SizedBox(width: spacing)).toList(),
        );
    }
  }
}
