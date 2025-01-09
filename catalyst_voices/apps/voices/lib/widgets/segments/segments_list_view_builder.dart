import 'package:catalyst_voices/widgets/segments/segments_controller.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class SegmentsListViewBuilder extends StatelessWidget {
  final ValueWidgetBuilder<List<SegmentsListViewItem>> builder;
  final Widget? child;

  const SegmentsListViewBuilder({
    super.key,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: SegmentsControllerScope.of(context),
      builder: (context, value, child) {
        return builder(context, value.listItems, child);
      },
    );
  }
}
