import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/widgets.dart';

typedef FeatureFlagWidgetBuilder =
    Widget Function(
      BuildContext context,
      Widget? child,
      // ignore: avoid_positional_boolean_parameters
      bool isEnabled,
    );

class FeatureFlagBuilder extends StatelessWidget {
  final FeatureFlag featureFlag;
  final FeatureFlagWidgetBuilder builder;
  final Widget? child;

  const FeatureFlagBuilder({
    super.key,
    required this.featureFlag,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<FeatureFlagsCubit, FeatureFlagsState, bool>(
      selector: (state) => state.isEnabled(featureFlag),
      builder: (context, isEnabled) {
        return builder(context, child, isEnabled);
      },
    );
  }
}
