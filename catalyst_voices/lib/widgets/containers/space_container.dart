import 'package:catalyst_voices/widgets/containers/tracks_container.dart';
import 'package:flutter/material.dart';

class SpaceContainer extends StatelessWidget {
  final Widget left;
  final Widget right;
  final Widget child;

  const SpaceContainer({
    super.key,
    required this.left,
    required this.right,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TracksContainer(
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
