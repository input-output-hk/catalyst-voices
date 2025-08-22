import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/widgets.dart';

extension VotingPowerStatusViewModel on VotingPowerStatus {
  String localizedName(BuildContext context) {
    return switch (this) {
      VotingPowerStatus.provisional => context.l10n.provisional,
      VotingPowerStatus.confirmed => context.l10n.confirmed,
    };
  }
}
