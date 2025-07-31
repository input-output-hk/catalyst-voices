import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
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
    return switch (this) {
      VotingPowerStatus.provisional => context.l10n.provisional,
      VotingPowerStatus.confirmed => context.l10n.confirmed,
      null => '                ', // reserve space for actual status
    };
  }
}
