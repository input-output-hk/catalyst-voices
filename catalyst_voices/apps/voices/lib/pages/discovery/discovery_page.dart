import 'dart:async';

import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices/pages/discovery/current_status_text.dart';
import 'package:catalyst_voices/pages/discovery/toggle_state_text.dart';
import 'package:catalyst_voices/widgets/cards/pending_proposal_card.dart';
import 'package:catalyst_voices/widgets/empty_state/empty_state.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoveryPage extends StatelessWidget {
  const DiscoveryPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        _Body(),
        SliverFillRemaining(
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

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        return switch (state) {
          VisitorSessionState() => const _GuestVisitorBody(),
          GuestSessionState() => const _GuestVisitorBody(),
          ActiveAccountSessionState() => const _ActiveAccountBody(),
        };
      },
    );
  }
}

class _GuestVisitorBody extends StatelessWidget {
  const _GuestVisitorBody();

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
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
      ],
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({super.key});

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

class _ActiveAccountBody extends StatelessWidget {
  const _ActiveAccountBody();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 32)
          .add(const EdgeInsets.only(bottom: 32)),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            const SizedBox(height: 16),
            const _Header(),
            const SizedBox(height: 40),
            const _Tabs(),
          ],
        ),
      ),
    );
  }
}

final _proposalDescription = """
Zanzibar is becoming one of the hotspots for DID's through
World Mobile and PRISM, but its potential is only barely exploited.
Zanzibar is becoming one of the hotspots for DID's through World Mobile
and PRISM, but its potential is only barely exploited.
"""
    .replaceAll('\n', ' ');

final _proposals = [
  PendingProposal(
    id: 'f14/0',
    fund: 'F14',
    category: 'Cardano Use Cases / MVP',
    title: 'Proposal Title that rocks the world',
    lastUpdateDate: DateTime.now().minusDays(2),
    fundsRequested: Coin.fromAda(100000),
    commentsCount: 0,
    description: _proposalDescription,
    completedSegments: 0,
    totalSegments: 13,
  ),
  PendingProposal(
    id: 'f14/1',
    fund: 'F14',
    category: 'Cardano Use Cases / MVP',
    title: 'Proposal Title that rocks the world',
    lastUpdateDate: DateTime.now().minusDays(2),
    fundsRequested: Coin.fromAda(100000),
    commentsCount: 0,
    description: _proposalDescription,
    completedSegments: 7,
    totalSegments: 13,
  ),
  PendingProposal(
    id: 'f14/2',
    fund: 'F14',
    category: 'Cardano Use Cases / MVP',
    title: 'Proposal Title that rocks the world',
    lastUpdateDate: DateTime.now().minusDays(2),
    fundsRequested: Coin.fromAda(100000),
    commentsCount: 0,
    description: _proposalDescription,
    completedSegments: 13,
    totalSegments: 13,
  ),
];

final _proposalImages = {
  for (final (index, proposal) in _proposals.indexed)
    proposal.id: index.isEven
        ? VoicesAssets.images.proposalBackground1
        : VoicesAssets.images.proposalBackground2,
};

final _favoriteProposals = ValueNotifier<List<PendingProposal>>([]);

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 680),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.spaceDiscoveryName,
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 24),
            Text(
              context.l10n.discoverySpaceTitle,
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.discoverySpaceDescription,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              onPressed: () {
                // TODO(dtscalac): show campaign details dialog
              },
              label: Text(context.l10n.campaignDetails),
              icon: VoicesAssets.icons.arrowsExpand.buildIcon(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(
                text: context.l10n.noOfAllProposals(_proposals.length),
              ),
              Tab(
                child: Row(
                  children: [
                    VoicesAssets.icons.starOutlined.buildIcon(),
                    const SizedBox(width: 8),
                    Text(context.l10n.favorites),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const TabBarStackView(
            children: [
              _AllProposals(),
              _FavoriteProposals(),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _AllProposals extends StatelessWidget {
  const _AllProposals();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<PendingProposal>>(
      valueListenable: _favoriteProposals,
      builder: (context, favoriteProposals, child) {
        if (_proposals.isEmpty) {
          return const _EmptyProposals();
        }

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (final proposal in _proposals)
              PendingProposalCard(
                image: _proposalImages[proposal.id]!,
                proposal: proposal,
                isFavorite: favoriteProposals.contains(proposal),
                onFavoriteChanged: (isFavorite) =>
                    _onFavoriteChanged(proposal, isFavorite),
              ),
          ],
        );
      },
    );
  }
}

class _FavoriteProposals extends StatelessWidget {
  const _FavoriteProposals();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<PendingProposal>>(
      valueListenable: _favoriteProposals,
      builder: (context, favoriteProposals, child) {
        if (favoriteProposals.isEmpty) {
          return const _EmptyProposals();
        }

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (final proposal in favoriteProposals)
              PendingProposalCard(
                image: _proposalImages[proposal.id]!,
                proposal: proposal,
                isFavorite: true,
                onFavoriteChanged: (isFavorite) =>
                    _onFavoriteChanged(proposal, isFavorite),
              ),
          ],
        );
      },
    );
  }
}

void _onFavoriteChanged(PendingProposal proposal, bool isFavorite) {
  final proposals = Set.of(_favoriteProposals.value);
  if (isFavorite) {
    proposals.add(proposal);
  } else {
    proposals.remove(proposal);
  }
  _favoriteProposals.value = proposals.toList();
}

class _EmptyProposals extends StatelessWidget {
  const _EmptyProposals();

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      description: context.l10n.discoverySpaceEmptyProposals,
    );
  }
}
