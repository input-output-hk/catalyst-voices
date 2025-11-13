import 'package:catalyst_voices/pages/dev_tools/cards/info_card.dart';
import 'package:catalyst_voices/pages/dev_tools/cards/widgets/feature_flags_card/feature_flags_table.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class FeatureFlagsCard extends StatelessWidget {
  const FeatureFlagsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InfoCard(
      title: const Text('Feature Flags'),
      children: [
        BlocSelector<FeatureFlagsCubit, FeatureFlagsState, Map<FeatureType, FeatureFlagInfo>>(
          selector: (state) => state.featureFlags,
          builder: (context, featureFlags) => FeatureFlagsTable(featureFlags),
        ),
      ],
    );
  }
}
