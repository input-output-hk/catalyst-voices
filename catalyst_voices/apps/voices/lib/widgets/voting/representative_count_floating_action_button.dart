import 'package:catalyst_voices/widgets/buttons/voices_counter_floating_action_button.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class RepresentativeCountFloatingActionButton extends StatelessWidget {
  final int count;
  final bool useGradient;
  final VoidCallback? onTap;

  const RepresentativeCountFloatingActionButton({
    super.key,
    this.count = 0,
    this.useGradient = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesCounterFloatingActionButton(
      title: context.l10n.repsList,
      count: count,
      countLabel: context.l10n.xRepsAdded(count),
      useGradient: useGradient,
      onTap: onTap,
    );
  }
}
