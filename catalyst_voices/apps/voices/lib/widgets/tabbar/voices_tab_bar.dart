import 'package:catalyst_voices/widgets/tabbar/voices_tab.dart';
import 'package:flutter/material.dart';

/// A custom [TabBar].
class VoicesTabBar<T extends Object> extends StatelessWidget {
  final List<VoicesTab<T>> tabs;
  final TabController? controller;
  final ValueChanged<VoicesTab<T>>? onTap;
  final TabBarIndicatorSize? indicatorSize;
  final TabAlignment? tabAlignment;

  const VoicesTabBar({
    super.key,
    required this.tabs,
    this.controller,
    this.onTap,
    this.indicatorSize,
    this.tabAlignment = TabAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      isScrollable: true,
      dividerHeight: 0,
      indicatorSize: indicatorSize,
      tabAlignment: tabAlignment,
      onTap: onTap != null ? _onTap : null,
      tabs: [
        for (final tab in tabs)
          Offstage(
            offstage: tab.isOffstage,
            child: Tab(
              key: tab.key ?? ValueKey(tab.data),
              text: tab.text,
            ),
          ),
      ],
    );
  }

  void _onTap(int index) {
    onTap?.call(tabs[index]);
  }
}
