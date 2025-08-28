import 'package:catalyst_voices/widgets/tabbar/voices_tab.dart';
import 'package:flutter/material.dart';

/// A custom [TabBar].
class VoicesTabBar<T extends Object> extends StatelessWidget {
  final List<VoicesTab<T>> tabs;
  final TabController? controller;
  final double? dividerHeight;
  final TabBarIndicatorSize? indicatorSize;
  final TabAlignment? tabAlignment;
  final ValueChanged<VoicesTab<T>>? onTap;

  const VoicesTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.dividerHeight,
    this.indicatorSize,
    this.tabAlignment = TabAlignment.start,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      isScrollable: true,
      dividerHeight: dividerHeight,
      indicatorSize: indicatorSize,
      tabAlignment: tabAlignment,
      onTap: onTap != null ? _onTap : null,
      tabs: [
        for (final tab in tabs)
          Tab(
            key: tab.key ?? ValueKey(tab.data),
            child: tab.child,
          ),
      ],
    );
  }

  void _onTap(int index) {
    onTap?.call(tabs[index]);
  }
}
