import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/widgets.dart';

class FeatureFlagWidget extends StatelessWidget {
  final Feature feature;
  final WidgetBuilder enabledChild;
  final WidgetBuilder? disabledChild;

  const FeatureFlagWidget({
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
        return enabled
            ? enabledChild(context)
            : (disabledChild?.call(context) ?? const SizedBox.shrink());
      },
    );
  }
}
