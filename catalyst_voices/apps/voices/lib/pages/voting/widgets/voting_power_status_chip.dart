import 'dart:math';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

typedef _VotingPowerStatusChipDecoration = ({
  Widget? leading,
  Color? backgroundColor,
  Color? borderColor,
  String title,
  TextStyle? textStyle,
});

class VotingPowerStatusChip extends StatelessWidget {
  final VotingPowerStatus? status;

  const VotingPowerStatusChip({
    super.key,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    final decoration = status.getDecoration(context);
    return VoicesChip(
      leading: decoration.leading,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      borderRadius: BorderRadius.circular(8),
      backgroundColor: decoration.backgroundColor,
      borderColor: decoration.borderColor,
      content: Text(
        decoration.title,
        style: decoration.textStyle,
      ),
    );
  }
}

extension on VotingPowerStatus? {
  _VotingPowerStatusChipDecoration getDecoration(BuildContext context) {
    final colors = context.colors;
    final textStyle = context.textTheme.labelSmall;
    return switch (this) {
      VotingPowerStatus.provisional || null => (
        leading: null,
        backgroundColor: colors.onSurfacePrimary016,
        borderColor: null,
        title: localizedName(context),
        textStyle: textStyle?.copyWith(color: colors.textOnPrimaryLevel1),
      ),
      VotingPowerStatus.confirmed => (
        leading: VoicesAssets.icons.check.buildIcon(color: colors.success),
        backgroundColor: null,
        borderColor: colors.iconsSuccess,
        title: localizedName(context),
        textStyle: textStyle?.copyWith(color: colors.success),
      ),
    };
  }

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
