import 'package:catalyst_voices/widgets/containers/sidebar_scaffold.dart';
import 'package:catalyst_voices/widgets/containers/space_side_panel.dart';
import 'package:flutter/material.dart';

/// Space screen structure implementation. This widget
/// does not require any specific child types but
/// is common to use [SpaceSidePanel] as [left] and [right].
///
/// Only difference from [SidebarScaffold] is that main content, [body],
/// has maxWidth so it does not expand indefinitely but spacing
/// between [body] and [left],[right] does.
class SpaceScaffold extends StatelessWidget {
  final Widget left;
  final Widget body;
  final Widget right;

  const SpaceScaffold({
    super.key,
    required this.left,
    required this.body,
    required this.right,
  });

  @override
  Widget build(BuildContext context) {
    return SidebarScaffold(
      leftRail: left,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 612),
          child: body,
        ),
      ),
      rightRail: right,
    );
  }
}
