import 'package:flutter/material.dart';

class HeaderAndContentLayout extends StatelessWidget {
  final Widget header;
  final Widget content;
  final Widget? background;

  const HeaderAndContentLayout({
    super.key,
    required this.header,
    required this.content,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (background != null) background!,
        CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
              ).add(const EdgeInsets.only(bottom: 32)),
              sliver: SliverList(
                delegate: SliverChildListDelegate(
                  [
                    header,
                    const SizedBox(height: 40),
                    content,
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
