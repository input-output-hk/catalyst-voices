import 'package:catalyst_voices/widgets/containers/space_side_panel.dart';
import 'package:flutter/material.dart';

/// Widget that creates 'rails' screen structure where two side panels
/// can be added with main content between them.
///
/// |panel |  content  |panel|.
///
/// Usually [leftRail] and [rightRail] are used with [SpaceSidePanel].
///
/// At the moment we do not have defined behaviour when we don't have
/// sufficient screen width for all content. Medium and small screens behaviour
/// will be implemented later. Right now only desktops are focused.
class SidebarScaffold extends StatelessWidget {
  final Widget leftRail;
  final Widget rightRail;
  final double railWidth;
  final double railsGap;
  final double childMaxWidth;
  final Widget child;

  const SidebarScaffold({
    super.key,
    this.leftRail = const SizedBox(),
    this.rightRail = const SizedBox(),
    this.railWidth = 326,
    this.railsGap = 56,
    this.childMaxWidth = 612,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: railWidth),
          child: leftRail,
        ),
        SizedBox(width: railsGap),
        Expanded(child: child),
        SizedBox(width: railsGap),
        ConstrainedBox(
          constraints: BoxConstraints.tightFor(width: railWidth),
          child: rightRail,
        ),
      ],
    );
  }
}
