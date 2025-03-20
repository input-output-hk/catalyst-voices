import 'package:flutter/material.dart';

class SidebarPanel extends StatefulWidget {
  final bool isLeft;
  final bool isCollapsed;
  final Widget header;
  final Widget body;

  const SidebarPanel({
    super.key,
    required this.isLeft,
    this.isCollapsed = false,
    required this.header,
    required this.body,
  });

  @override
  State<SidebarPanel> createState() => _SidebarPanelState();
}

class _SidebarPanelState extends State<SidebarPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _animation;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.header,
        Expanded(
          child: SlideTransition(
            position: _animation,
            child: widget.body,
          ),
        ),
      ],
    );
  }

  @override
  void didUpdateWidget(SidebarPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCollapsed != oldWidget.isCollapsed) {
      if (widget.isCollapsed) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      value: widget.isCollapsed ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: widget.isLeft ? const Offset(-1, 0) : const Offset(1, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
  }
}
