import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

extension VoteTypeViewModel on VoteType {
  SvgGenImage icon() {
    return switch (this) {
      VoteType.yes => VoicesAssets.icons.thumbUp,
      VoteType.abstain => VoicesAssets.icons.minus,
    };
  }

  String localisedName(BuildContext context) {
    return switch (this) {
      VoteType.yes => 'Yes',
      VoteType.abstain => 'Abstain',
    };
  }
}
