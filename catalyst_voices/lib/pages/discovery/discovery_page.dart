import 'dart:async';

import 'package:catalyst_voices/pages/discovery/current_status_text.dart';
import 'package:catalyst_voices/pages/discovery/toggle_state_text.dart';
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
                const _Segment(key: ValueKey('Segment1Key')),
                const SizedBox(height: 24),
                const _Segment(key: ValueKey('Segment2Key')),
                const SizedBox(height: 24),
                const _Segment(key: ValueKey('Segment3Key')),
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
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AspectRatio(
      aspectRatio: 1376 / 673,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colors.elevationsOnSurfaceNeutralLv1White,
          border: Border.all(color: theme.colors.outlineBorderVariant!),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CurrentUserStatusText(),
            const SizedBox(height: 8),
            const ToggleStateText(),
            const Spacer(),
            VoicesFilledButton(
              child: const Text('CTA to Model'),
              onTap: () {
                unawaited(
                  VoicesDialog.show<void>(
                    context: context,
                    builder: (context) {
                      return const VoicesDesktopInfoDialog(title: Text(''));
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
