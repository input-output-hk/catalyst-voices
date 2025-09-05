import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
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
        _Foreground(
          header: header,
          content: content,
          separateHeaderAndContent: separateHeaderAndContent,
        ),
      ],
    );
  }
}

class _Foreground extends StatelessWidget {
  final Widget header;
  final Widget content;
  final bool separateHeaderAndContent;

  const _Foreground({
    required this.header,
    required this.content,
    required this.separateHeaderAndContent,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder<EdgeInsetsGeometry>(
      lg: const EdgeInsetsGeometry.symmetric(horizontal: 32),
      other: const EdgeInsetsGeometry.symmetric(horizontal: 16),
      builder: (context, data) {
        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: data,
              sliver: SliverToBoxAdapter(child: header),
            ),
            if (separateHeaderAndContent) const SliverToBoxAdapter(child: SizedBox(height: 40)),
            SliverPadding(
              padding: data,
              sliver: SliverFillRemaining(hasScrollBody: false, child: content),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        );
      },
    );
  }
}
