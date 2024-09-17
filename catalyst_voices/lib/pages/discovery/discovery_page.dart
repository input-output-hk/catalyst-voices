import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class DiscoveryPage extends StatelessWidget {
  const DiscoveryPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: _SpacesNavigationLocation()),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 32)
              .add(const EdgeInsets.only(bottom: 32)),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                const _Segment(name: 'Segment 1'),
                const SizedBox(height: 24),
                const _Segment(name: 'Segment 2'),
                const SizedBox(height: 24),
                const _Segment(name: 'Segment 3'),
              ],
            ),
          ),
        ),
        const SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            children: [
              Spacer(),
              StandardLinksPageFooter(),
            ],
          ),
        ),
      ],
    );
  }
}

class _SpacesNavigationLocation extends StatelessWidget {
  const _SpacesNavigationLocation();

  @override
  Widget build(BuildContext context) {
    return const NavigationLocation(
      parts: [
        'Discovery Space',
        'Homepage',
      ],
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AspectRatio(
      aspectRatio: 1376 / 673,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colors.onSurfaceNeutralOpaqueLv1,
          border: Border.all(color: theme.colors.outlineBorderVariant!),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colors.textOnPrimary,
              ),
            ),
            const Spacer(),
            VoicesFilledButton(
              child: const Text('CTA to Model'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
