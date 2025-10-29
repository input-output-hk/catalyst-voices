import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/widgets.dart';

class FeatureFlag extends StatelessWidget {
  final Feature feature;
  final Widget featureChild;
  final Widget? fallbackChild;

  const FeatureFlag({
    super.key,
    required this.feature,
    required this.featureChild,
    this.fallbackChild,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<FeatureFlagsCubit, FeatureFlagsState, bool>(
      selector: (state) => state.isEnabled(feature),
      builder: (context, enabled) {
        return enabled ? featureChild : (fallbackChild ?? const SizedBox.shrink());
      },
    );
  }
}
