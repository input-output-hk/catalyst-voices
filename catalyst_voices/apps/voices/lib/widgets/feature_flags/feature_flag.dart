import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/widgets.dart';

class FeatureFlag extends StatelessWidget {
  final Feature feature;
  final Widget enabledChild;
  final Widget? disabledChild;

  const FeatureFlag({
    super.key,
    required this.feature,
    required this.enabledChild,
    this.disabledChild,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<FeatureFlagsCubit, FeatureFlagsState, bool>(
      selector: (state) => state.isEnabled(feature),
      builder: (context, enabled) {
        return enabled ? enabledChild : (disabledChild ?? const SizedBox.shrink());
      },
    );
  }
}
