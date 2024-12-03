import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

final _proposalDescription = """
Zanzibar is becoming one of the hotspots for DID's through
World Mobile and PRISM, but its potential is only barely exploited.
Zanzibar is becoming one of the hotspots for DID's through World Mobile
and PRISM, but its potential is only barely exploited.
"""
    .replaceAll('\n', ' ');

final _proposals = [
  FundedProposal(
    id: 'f14/0',
    campaignName: 'F14',
    category: 'Cardano Use Cases / MVP',
    title: 'Proposal Title that rocks the world',
    fundedDate: DateTime.now().minusDays(2),
    fundsRequested: CryptocurrencyFormatter.formatAmount(Coin.fromAda(100000)),
    commentsCount: 0,
    description: _proposalDescription,
  ),
  FundedProposal(
    id: 'f14/1',
    campaignName: 'F14',
    category: 'Cardano Use Cases / MVP',
    title: 'Proposal Title that rocks the world',
    fundedDate: DateTime.now().minusDays(2),
    fundsRequested: CryptocurrencyFormatter.formatAmount(Coin.fromAda(100000)),
    commentsCount: 0,
    description: _proposalDescription,
  ),
  FundedProposal(
    id: 'f14/2',
    campaignName: 'F14',
    category: 'Cardano Use Cases / MVP',
    title: 'Proposal Title that rocks the world',
    fundedDate: DateTime.now().minusDays(2),
    fundsRequested: CryptocurrencyFormatter.formatAmount(Coin.fromAda(100000)),
    commentsCount: 0,
    description: _proposalDescription,
  ),
];

final _proposalImages = {
  for (final (index, proposal) in _proposals.indexed)
    proposal.id: index.isEven
        ? VoicesAssets.images.proposalBackground1
        : VoicesAssets.images.proposalBackground2,
};

final _favoriteProposals = ValueNotifier<List<FundedProposal>>([]);

class FundedProjectsPage extends StatelessWidget {
  const FundedProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      children: [
        const SizedBox(height: 44),
        Text(
          context.l10n.fundedProjectSpace,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: 44),
        const _Tabs(),
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
                text: context.l10n.noOfFundedProposals(_proposals.length),
              ),
              Tab(
                child: Row(
                  children: [
                    VoicesAssets.icons.plusCircleOutlined.buildIcon(),
                    const SizedBox(width: 8),
                    Text(context.l10n.followed),
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
    return ValueListenableBuilder<List<FundedProposal>>(
      valueListenable: _favoriteProposals,
      builder: (context, favoriteProposals, child) {
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (final proposal in _proposals)
              FundedProposalCard(
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
    return ValueListenableBuilder<List<FundedProposal>>(
      valueListenable: _favoriteProposals,
      builder: (context, favoriteProposals, child) {
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (final proposal in favoriteProposals)
              FundedProposalCard(
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

void _onFavoriteChanged(FundedProposal proposal, bool isFavorite) {
  final proposals = Set.of(_favoriteProposals.value);
  if (isFavorite) {
    proposals.add(proposal);
  } else {
    proposals.remove(proposal);
  }
  _favoriteProposals.value = proposals.toList();
}
