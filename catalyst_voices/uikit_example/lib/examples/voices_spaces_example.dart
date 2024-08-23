import 'package:catalyst_voices/widgets/app_bar/voices_app_bar.dart';
import 'package:catalyst_voices/widgets/drawer/voices_drawer.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

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
          VoicesAvatar(icon: Text('L')),
        ],
      ),
      drawer: const VoicesDrawer(children: []),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: _NavigationLocation()),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 32)
                .add(const EdgeInsets.only(bottom: 32)),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  const _Segment(),
                  const SizedBox(height: 24),
                  const _Segment(),
                  const SizedBox(height: 24),
                  const _Segment(),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: _Footer()),
        ],
      ),
    );
  }
}

class _NavigationLocation extends StatelessWidget {
  const _NavigationLocation();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colors.textOnPrimary,
                ),
            children: const [
              TextSpan(
                text: 'Discovery Space',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: ' / '),
              TextSpan(text: 'Homepage'),
            ]),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment();

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
              'Segment',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colors.textOnPrimary,
              ),
            ),
            const Spacer(),
            VoicesFilledButton(
              child: const Text('CTA to Model'),
              onTap: () {},
            )
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final icons = VoicesAssets.internalResources.icons;

    return LinksPageFooter(
      upperChildren: [
        LinkText('About us', onTap: () {}),
        LinkText('Funds', onTap: () {}),
        LinkText('Documentation', onTap: () {}),
        LinkText('Contact us', onTap: () {}),
      ],
      lowerChildren: [
        VoicesIconButton(
          child: icons.facebookMono.build(),
          onTap: () {},
        ),
        VoicesIconButton(
          child: icons.linkedinMono.build(),
          onTap: () {},
        ),
        VoicesIconButton(
          child: icons.xMono.build(),
          onTap: () {},
        ),
      ],
    );
  }
}
