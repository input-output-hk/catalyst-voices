import 'package:catalyst_voices/widgets/common/simple_tree_view.dart';
import 'package:catalyst_voices/widgets/menu/voices_node_menu.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class VoicesNodeMenuPlaceholder extends StatelessWidget {
  final bool isExpanded;
  final int childrenCount;

  const VoicesNodeMenuPlaceholder({
    super.key,
    this.isExpanded = false,
    this.childrenCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleTreeView(
      isExpanded: isExpanded,
      root: SimpleTreeViewRootRow(
        leading: [
          VoicesNodeMenuIcon(isOpen: isExpanded),
          const _Placeholder(width: 16),
        ],
        child: const _Placeholder(),
      ),
      children: [
        for (int i = 0; i < childrenCount; i++)
          SimpleTreeViewChildRow(
            hasNext: i != childrenCount - 1,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _Placeholder(
                width: 90,
                color: Theme.of(context).colors.iconsDisabled.withAlpha(100),
              ),
            ),
          ),
      ],
    );
  }
}

class _Placeholder extends StatelessWidget {
  final double width;
  final Color? color;

  const _Placeholder({
    this.width = 110,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 16,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
