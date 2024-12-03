import 'dart:async';

import 'package:catalyst_voices/pages/campaign/details/campaign_details_dialog.dart';
import 'package:catalyst_voices/pages/discovery/current_status_text.dart';
import 'package:catalyst_voices/pages/discovery/toggle_state_text.dart';
import 'package:catalyst_voices/widgets/cards/pending_proposal_card.dart';
import 'package:catalyst_voices/widgets/empty_state/empty_state.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({super.key});

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {
  @override
  void initState() {
    super.initState();
    unawaited(context.read<ProposalsCubit>().load());
  }

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        _Body(),
        _Footer(),
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
              onPressed: () async {
                // TODO(dtscalac): pass correct campaign id
                await CampaignDetailsDialog.show(context, id: '1');
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
    return const DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TabBar(),
          SizedBox(height: 24),
          TabBarStackView(
            children: [
              _AllProposals(),
              _FavoriteProposals(),
            ],
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _TabBar extends StatelessWidget {
  const _TabBar();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProposalsCubit, ProposalsState, int>(
      selector: (state) =>
          state is LoadedProposalsState ? state.proposals.length : 0,
      builder: (context, proposalsCount) {
        return TabBar(
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [
            Tab(
              text: context.l10n.noOfAllProposals(proposalsCount),
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
        );
      },
    );
  }
}

class _AllProposals extends StatelessWidget {
  const _AllProposals();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProposalsCubit, ProposalsState>(
      builder: (context, state) {
        return switch (state) {
          LoadingProposalsState() => const _LoadingProposals(),
          LoadedProposalsState(:final proposals, :final favoriteProposals) =>
            proposals.isEmpty
                ? const _EmptyProposals()
                : _AllProposalsList(
                    proposals: proposals,
                    favoriteProposals: favoriteProposals,
                  ),
        };
      },
    );
  }
}

class _AllProposalsList extends StatelessWidget {
  final List<PendingProposal> proposals;
  final List<PendingProposal> favoriteProposals;

  const _AllProposalsList({
    required this.proposals,
    required this.favoriteProposals,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        for (final proposal in proposals)
          PendingProposalCard(
            image: _generateImageForProposal(proposal.id),
            proposal: proposal,
            showStatus: false,
            showLastUpdate: false,
            showComments: false,
            showSegments: false,
            isFavorite: favoriteProposals.contains(proposal),
            onFavoriteChanged: (isFavorite) async {
              if (isFavorite) {
                await context
                    .read<ProposalsCubit>()
                    .onFavoriteProposal(proposal.id);
              } else {
                await context
                    .read<ProposalsCubit>()
                    .onUnfavoriteProposal(proposal.id);
              }
            },
          ),
      ],
    );
  }
}

class _FavoriteProposals extends StatelessWidget {
  const _FavoriteProposals();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProposalsCubit, ProposalsState>(
      builder: (context, state) {
        return switch (state) {
          LoadingProposalsState() => const _LoadingProposals(),
          LoadedProposalsState(:final favoriteProposals) =>
            favoriteProposals.isEmpty
                ? const _EmptyProposals()
                : _FavoriteProposalsList(
                    proposals: favoriteProposals,
                  ),
        };
      },
    );
  }
}

class _FavoriteProposalsList extends StatelessWidget {
  final List<PendingProposal> proposals;

  const _FavoriteProposalsList({required this.proposals});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        for (final proposal in proposals)
          PendingProposalCard(
            image: _generateImageForProposal(proposal.id),
            proposal: proposal,
            showStatus: false,
            showLastUpdate: false,
            showComments: false,
            showSegments: false,
            isFavorite: true,
            onFavoriteChanged: (isFavorite) async {
              if (isFavorite) {
                await context
                    .read<ProposalsCubit>()
                    .onFavoriteProposal(proposal.id);
              } else {
                await context
                    .read<ProposalsCubit>()
                    .onUnfavoriteProposal(proposal.id);
              }
            },
          ),
      ],
    );
  }
}

class _LoadingProposals extends StatelessWidget {
  const _LoadingProposals();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(64),
        child: VoicesCircularProgressIndicator(),
      ),
    );
  }
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

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return const SliverFillRemaining(
      hasScrollBody: false,
      child: Column(
        children: [
          Spacer(),
          StandardLinksPageFooter(),
        ],
      ),
    );
  }
}

AssetGenImage _generateImageForProposal(String id) {
  return id.codeUnits.last.isEven
      ? VoicesAssets.images.proposalBackground1
      : VoicesAssets.images.proposalBackground2;
}
