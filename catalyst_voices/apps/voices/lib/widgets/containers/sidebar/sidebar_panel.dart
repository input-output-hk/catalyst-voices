import 'package:catalyst_voices/widgets/widgets.dart';
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
  late final Animation<double> _sizeAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final width = constraints.constrainWidth() * _sizeAnimation.value;

            return ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: width),
              child: child,
            );
          },
          child: Column(
            children: [
              widget.header,
              Expanded(
                child: PageOverflow(
                  width: constraints.maxWidth,
                  alignment: Alignment.centerRight,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: IgnorePointer(
                      ignoring: widget.isCollapsed,
                      child: widget.body,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );

    _sizeAnimation = Tween<double>(begin: 1, end: 0.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
    _fadeAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );
  }
}
