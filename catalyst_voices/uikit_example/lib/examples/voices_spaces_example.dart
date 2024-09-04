import 'package:catalyst_voices/widgets/app_bar/voices_app_bar.dart';
import 'package:catalyst_voices/widgets/drawer/voices_drawer.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';
import 'package:uikit_example/widgets/session_header.dart';

class VoicesSpacesExample extends StatelessWidget {
  static const String route = '/spaces-example';

  const VoicesSpacesExample({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const VoicesAppBar(
        actions: [
          SessionHeader(),
        ],
      ),
      drawer: const VoicesDrawer(children: []),
      body: CustomScrollView(
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
      ),
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
