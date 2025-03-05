import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:flutter/material.dart';

typedef FirstAndLast = ({bool isFirst, bool isLast});

class ProposalSeparatorBox extends StatelessWidget {
  final double height;

  const ProposalSeparatorBox({
    super.key,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colors.elevationsOnSurfaceNeutralLv0,
      child: SizedBox(height: height),
    );
  }
}

class ProposalTileDecoration extends StatelessWidget {
  final FirstAndLast corners;
  final FirstAndLast verticalPadding;
  final Widget child;

  const ProposalTileDecoration({
    super.key,
    this.corners = (isFirst: false, isLast: false),
    this.verticalPadding = (isFirst: false, isLast: false),
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 32);

    if (verticalPadding.isFirst) {
      padding = padding.add(const EdgeInsets.only(top: 32));
    }
    if (verticalPadding.isLast) {
      padding = padding.add(const EdgeInsets.only(bottom: 32));
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.elevationsOnSurfaceNeutralLv0,
        borderRadius: BorderRadius.vertical(
          top: corners.isFirst ? const Radius.circular(16) : Radius.zero,
          bottom: corners.isLast ? const Radius.circular(16) : Radius.zero,
        ),
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
