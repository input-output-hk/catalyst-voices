import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices/widgets/cards/pending_proposal_card.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    campaignName: 'F14',
    category: 'Cardano Use Cases / MVP',
    title: 'Proposal Title that rocks the world',
    lastUpdateDate: DateTime.now().minusDays(2),
    fundsRequested: CryptocurrencyFormatter.formatAmount(Coin.fromAda(100000)),
    commentsCount: 0,
    description: _proposalDescription,
    completedSegments: 0,
    totalSegments: 13,
  ),
  PendingProposal(
    id: 'f14/1',
    campaignName: 'F14',
    category: 'Cardano Use Cases / MVP',
    title: 'Proposal Title that rocks the world',
    lastUpdateDate: DateTime.now().minusDays(2),
    fundsRequested: CryptocurrencyFormatter.formatAmount(Coin.fromAda(100000)),
    commentsCount: 0,
    description: _proposalDescription,
    completedSegments: 7,
    totalSegments: 13,
  ),
  PendingProposal(
    id: 'f14/2',
    campaignName: 'F14',
    category: 'Cardano Use Cases / MVP',
    title: 'Proposal Title that rocks the world',
    lastUpdateDate: DateTime.now().minusDays(2),
    fundsRequested: CryptocurrencyFormatter.formatAmount(Coin.fromAda(100000)),
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

class VotingPage extends StatelessWidget {
  const VotingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      children: const [
        SizedBox(height: 44),
        _Header(),
        SizedBox(height: 44),
        _Tabs(),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.l10n.activeVotingRound,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            if (state is ActiveAccountSessionState)
              const _UnlockedHeaderActions(),
          ],
        );
      },
    );
  }
}

class _UnlockedHeaderActions extends StatelessWidget {
  const _UnlockedHeaderActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 256,
          child: VoicesTextField(
            decoration: VoicesTextFieldDecoration(
              labelText: 'Show',
              hintText: 'Fund 14',
              suffixIcon:
                  VoicesAssets.icons.arrowTriangleDown.buildIcon(size: 16),
            ),
            onFieldSubmitted: (value) {},
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 256,
          child: VoicesTextField(
            decoration: VoicesTextFieldDecoration(
              labelText: 'Field label',
              hintText: 'Search proposals',
              prefixIcon: VoicesAssets.icons.search.buildIcon(),
            ),
            onFieldSubmitted: (value) {},
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: VoicesAssets.icons.filter.buildIcon(),
        ),
      ],
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
