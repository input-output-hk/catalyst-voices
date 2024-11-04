import 'package:catalyst_voices/widgets/containers/sidebar_scaffold.dart';
import 'package:catalyst_voices/widgets/containers/space_side_panel.dart';
import 'package:flutter/material.dart';

/// Space screen structure implementation. This widget
/// does not require any specific child types but
/// is common to use [SpaceSidePanel] as [left] and [right].
///
/// Only difference from [SidebarScaffold] is that main content, [child],
/// has maxWidth so it does not expand indefinitely but spacing
/// between [child] and [left],[right] does.
class SpaceScaffold extends StatelessWidget {
  final Widget left;
  final Widget right;
  final Widget child;

  const SpaceScaffold({
    super.key,
    required this.left,
    required this.right,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SidebarScaffold(
      leftRail: left,
      rightRail: right,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 612),
          child: child,
        ),
      ),
    );
  }
}
