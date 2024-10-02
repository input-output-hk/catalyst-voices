import 'package:catalyst_voices/widgets/common/delayed_widget.dart';
import 'package:catalyst_voices/widgets/indicators/voices_circular_progress_indicator.dart';
import 'package:flutter/material.dart';

class VoicesLoadable extends StatelessWidget {
  final bool isLoading;
  final WidgetBuilder loaderBuilder;
  final WidgetBuilder builder;

  const VoicesLoadable({
    super.key,
    this.isLoading = true,
    this.loaderBuilder = _defaultLoaderBuilder,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loaderBuilder(context);
    } else {
      return builder(context);
    }
  }
}

Widget _defaultLoaderBuilder(BuildContext context) {
  return const Center(
    child: DelayedWidget(
      child: VoicesCircularProgressIndicator(),
    ),
  );
}
