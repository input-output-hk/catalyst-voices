import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class SpaceSidePanelTab {
  final String name;
  final Widget body;

  SpaceSidePanelTab({
    required this.name,
    required this.body,
  });
}

class SpaceSidePanel extends StatelessWidget {
  final bool isLeft;
  final String name;
  final VoidCallback? onCollapseTap;
  final TabController? tabController;
  final List<SpaceSidePanelTab> tabs;
  final EdgeInsetsGeometry margin;

  const SpaceSidePanel({
    super.key,
    required this.isLeft,
    required this.name,
    this.onCollapseTap,
    this.tabController,
    required this.tabs,
    this.margin = const EdgeInsets.only(top: 10),
  });

  @override
  Widget build(BuildContext context) {
    return _Container(
      margin: margin,
      borderRadius: isLeft
          ? const BorderRadius.horizontal(right: Radius.circular(16))
          : const BorderRadius.horizontal(left: Radius.circular(16)),
      child: DefaultTabController(
        length: tabs.length,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Header(
              name: name,
              onCollapseTap: onCollapseTap,
              isLeft: isLeft,
            ),
            _Tabs(
              tabs,
              controller: tabController,
            ),
            const SizedBox(height: 12),
            // TODO(damian): uncomment when merged
            /*TabBarStackView(
              controller: tabController,
              children: tabs.map((e) => e.body).toList(),
            ),*/
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _Container extends StatelessWidget {
  final EdgeInsetsGeometry margin;
  final BorderRadiusGeometry borderRadius;
  final Widget child;

  const _Container({
    required this.margin,
    required this.borderRadius,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: Theme.of(context).colors.onSurfaceNeutralOpaqueLv0,
        borderRadius: borderRadius,
      ),
      padding: const EdgeInsets.all(12),
      child: child,
    );
  }
}

class _Header extends StatelessWidget {
  final String name;
  final VoidCallback? onCollapseTap;
  final bool isLeft;

  const _Header({
    required this.name,
    this.onCollapseTap,
    required this.isLeft,
  });

  @override
  Widget build(BuildContext context) {
    // TODO(damian): uncomment when merged
    /*return SectionHeader(
      leading: isLeft ? LeftArrowButton(onTap: onCollapseTap) : null,
      title: Text(name),
      trailing: [
        if (!isLeft) RightArrowButton(onTap: onCollapseTap),
      ],
    );*/

    return Offstage();
  }
}

class _Tabs extends StatelessWidget {
  final TabController? controller;
  final List<SpaceSidePanelTab> tabs;

  const _Tabs(
    this.tabs, {
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      tabs: tabs.map((e) => Tab(text: e.name)).toList(),
    );
  }
}
