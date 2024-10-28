import 'package:catalyst_voices/widgets/buttons/voices_buttons.dart';
import 'package:catalyst_voices/widgets/common/tab_bar_stack_view.dart';
import 'package:catalyst_voices/widgets/containers/space_scaffold.dart';
import 'package:catalyst_voices/widgets/headers/section_header.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

/// Defines [Tab] inside [SpaceSidePanel].
class SpaceSidePanelTab {
  /// Displayed label for this tab.
  final String name;

  /// What is shown when this tab is selected.
  // Note. This maybe should be [WidgetBuilder].
  final Widget body;

  SpaceSidePanelTab({
    required this.name,
    required this.body,
  });
}

/// Defines usual space panel. This widget is opinionated and should
/// be used together with [SpaceScaffold].
///
/// Always have [name], [tabs] and tabs content [SpaceSidePanelTab.body].
class SpaceSidePanel extends StatefulWidget {
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
  State<SpaceSidePanel> createState() => _SpaceSidePanelState();
}

class _SpaceSidePanelState extends State<SpaceSidePanel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: widget.isLeft ? const Offset(-1, 0) : const Offset(1, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.isLeft)
          Positioned(
            top: 28,
            left: 24,
            child: RightArrowButton(
              onTap: () {
                _controller.reverse();
              },
            ),
          )
        else
          Positioned(
            top: 28,
            right: 16,
            child: LeftArrowButton(
              onTap: () {
                _controller.reverse();
              },
            ),
          ),
        SlideTransition(
          position: _offsetAnimation,
          child: SingleChildScrollView(
            child: _Container(
              margin: widget.margin,
              borderRadius: widget.isLeft
                  ? const BorderRadius.horizontal(right: Radius.circular(16))
                  : const BorderRadius.horizontal(left: Radius.circular(16)),
              child: DefaultTabController(
                length: widget.tabs.length,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _Header(
                      name: widget.name,
                      onCollapseTap: () {
                        _controller.forward();
                        widget.onCollapseTap?.call();
                      },
                      isLeft: widget.isLeft,
                    ),
                    _Tabs(
                      widget.tabs,
                      controller: widget.tabController,
                    ),
                    const SizedBox(height: 12),
                    TabBarStackView(
                      controller: widget.tabController,
                      children: widget.tabs.map((e) => e.body).toList(),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
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
        color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv1White,
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
    return SectionHeader(
      leading: isLeft ? LeftArrowButton(onTap: onCollapseTap) : null,
      title: Text(name),
      trailing: [
        if (!isLeft) RightArrowButton(onTap: onCollapseTap),
      ],
    );
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
