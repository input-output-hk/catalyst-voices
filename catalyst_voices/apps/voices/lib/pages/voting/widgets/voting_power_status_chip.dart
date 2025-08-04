import 'dart:math';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class VotingPowerStatusChip extends StatelessWidget {
  final VotingPowerStatus? status;

  const VotingPowerStatusChip({
    super.key,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesChip(
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 4),
      borderRadius: BorderRadius.circular(4),
      backgroundColor: context.colors.onSurfacePrimary016,
      content: Text(
        status.localizedName(context),
        style: context.textTheme.labelSmall!.copyWith(color: context.colors.textOnPrimaryLevel1),
      ),
    );
  }
}

extension on VotingPowerStatus? {
  String localizedName(BuildContext context) {
    final instance = this;
    if (instance != null) {
      return instance.localizedName(context);
    }

    // reserve space for actual status
    final longestCount = VotingPowerStatus.values
        .map((e) => e.localizedName(context))
        .fold(0, (previousValue, element) => max(previousValue, element.length));

    // *2 because empty space is rendered ~ 2 times smaller then letter
    return List.generate(longestCount * 2, (_) => ' ').join();
  }
}
