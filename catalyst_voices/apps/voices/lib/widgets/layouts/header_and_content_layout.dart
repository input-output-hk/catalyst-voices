import 'package:flutter/material.dart';

class HeaderAndContentLayout extends StatelessWidget {
  final Widget header;
  final Widget content;
  final Widget? background;
  final bool separateHeaderAndContent;

  const HeaderAndContentLayout({
    super.key,
    required this.header,
    required this.content,
    this.background,
    this.separateHeaderAndContent = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (background != null) background!,
        CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsetsGeometry.symmetric(horizontal: 32),
              sliver: SliverToBoxAdapter(child: header),
            ),
            if (separateHeaderAndContent) const SliverToBoxAdapter(child: SizedBox(height: 40)),
            SliverPadding(
              padding: const EdgeInsetsGeometry.symmetric(horizontal: 32),
              sliver: SliverFillRemaining(hasScrollBody: false, child: content),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ],
    );
  }
}
