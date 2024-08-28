import 'package:flutter/material.dart';

class TracksContainer extends StatelessWidget {
  final Widget leftRail;
  final Widget rightRail;
  final double railWidth;
  final double railsGap;
  final double childMaxWidth;
  final Widget child;

  const TracksContainer({
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
