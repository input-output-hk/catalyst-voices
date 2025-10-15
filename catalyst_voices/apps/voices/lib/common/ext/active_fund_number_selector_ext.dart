import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:flutter/material.dart';

extension ActiveFundNumberSelectorExt on BuildContext {
  int get activeCampaignFundNumber {
    return select<CampaignPhaseAwareCubit, int>((cubit) => cubit.state.fundNumber);
  }
}
