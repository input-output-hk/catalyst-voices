import 'package:catalyst_voices/pages/spaces/spaces_drawer.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class SpacesShellPage extends StatelessWidget {
  final Space space;
  final Widget child;
  final bool showSearch;

  const SpacesShellPage({
    super.key,
    required this.space,
    required this.child,
    this.showSearch = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VoicesAppBar(showSearch: showSearch),
      drawer: SpacesDrawer(space: space),
      body: child,
    );
  }
}
