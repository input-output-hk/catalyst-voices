import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:flutter/material.dart';

typedef FirstAndLast = ({bool isFirst, bool isLast});

class ProposalTileDecoration extends StatelessWidget {
  final FirstAndLast position;
  final FirstAndLast positionInSegment;
  final Widget child;

  const ProposalTileDecoration({
    super.key,
    this.position = (isFirst: false, isLast: false),
    this.positionInSegment = (isFirst: false, isLast: false),
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 32);

    if (positionInSegment.isFirst) {
      padding = padding.add(const EdgeInsets.only(top: 32));
    }
    if (positionInSegment.isLast) {
      padding = padding.add(const EdgeInsets.only(bottom: 32));
    }

    return Container(
      decoration: BoxDecoration(
        color: context.colors.elevationsOnSurfaceNeutralLv0,
        borderRadius: BorderRadius.vertical(
          top: position.isFirst ? const Radius.circular(16) : Radius.zero,
          bottom: position.isLast ? const Radius.circular(16) : Radius.zero,
        ),
      ),
      padding: padding,
      child: child,
    );
  }
}
