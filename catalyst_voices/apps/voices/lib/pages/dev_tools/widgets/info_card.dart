import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final Widget title;
  final List<Widget> children;

  const InfoCard({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(8),
        color: context.colors.elevationsOnSurfaceNeutralLv1White,
      ),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Title(child: title),
          const SizedBox(height: 12),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 8,
            children: children,
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final Widget child;

  const _Title({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: (context.textTheme.titleLarge ?? const TextStyle())
          .copyWith(color: context.colors.textPrimary),
      child: child,
    );
  }
}
