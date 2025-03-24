import 'package:catalyst_voices/widgets/containers/sidebar/space_side_panel.dart';
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
  final Widget? leftRail;
  final Widget? rightRail;
  final BoxConstraints railConstraints;
  final BoxConstraints bodyConstraints;
  final double spacing;
  final Widget body;

  const SidebarScaffold({
    super.key,
    this.leftRail,
    this.rightRail,
    this.railConstraints = const BoxConstraints(maxWidth: 326),
    this.bodyConstraints = const BoxConstraints(maxWidth: 612),
    this.spacing = 56,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final leftRail = this.leftRail;
    final rightRail = this.rightRail;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: spacing,
      children: [
        if (leftRail != null)
          ConstrainedBox(
            constraints: railConstraints,
            child: leftRail,
          ),
        Flexible(
          child: Center(
            child: ConstrainedBox(
              constraints: bodyConstraints,
              child: body,
            ),
          ),
        ),
        if (rightRail != null)
          ConstrainedBox(
            constraints: railConstraints,
            child: rightRail,
          ),
      ],
    );
  }
}
