import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class SectionsListViewBuilder extends StatelessWidget {
  final ValueWidgetBuilder<List<SectionsListViewItem>> builder;
  final Widget? child;

  const SectionsListViewBuilder({
    super.key,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: SectionsControllerScope.of(context),
      builder: (context, value, child) {
        return builder(context, value.listItems, child);
      },
    );
  }
}
