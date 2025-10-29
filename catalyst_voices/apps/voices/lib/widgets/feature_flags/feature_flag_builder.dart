import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/widgets.dart';

typedef FeatureFlagWidgetBuilder =
    Widget Function(
      BuildContext context,
      Widget? child,
      FeatureFlagInfo? info,
    );

class FeatureFlagBuilder extends StatelessWidget {
  final Feature feature;
  final FeatureFlagWidgetBuilder builder;
  final Widget? child;

  const FeatureFlagBuilder({
    super.key,
    required this.feature,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<FeatureFlagsCubit, FeatureFlagsState, FeatureFlagInfo?>(
      selector: (state) => state.getFeature(feature),
      builder: (context, featureFlagInfo) {
        return builder(context, child, featureFlagInfo);
      },
    );
  }
}
