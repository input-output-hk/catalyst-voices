import 'package:flutter/material.dart';

class HeaderAndContentLayout extends StatelessWidget {
  final Widget header;
  final Widget content;

  const HeaderAndContentLayout({
    super.key,
    required this.header,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding:
              const EdgeInsets.symmetric(horizontal: 32).add(const EdgeInsets.only(bottom: 32)),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(height: 16),
                header,
                const SizedBox(height: 40),
                content,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
