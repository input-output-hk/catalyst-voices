import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

final _favoriteProposals = ValueNotifier<List<ProposalBrief>>([]);

final _proposalDescription = """
Zanzibar is becoming one of the hotspots for DID's through
World Mobile and PRISM, but its potential is only barely exploited.
Zanzibar is becoming one of the hotspots for DID's through World Mobile
and PRISM, but its potential is only barely exploited.
"""
    .replaceAll('\n', ' ');

final _proposals = [
  ProposalBrief(
    selfRef: SignedDocumentRef.generateFirstRef(),
    title: 'Proposal Title that rocks the world',
    categoryName: 'Cardano Use Cases / MVP',
    author: 'Alex Wells',
    fundsRequested: const Coin.fromWholeAda(100000),
    commentsCount: 0,
    description: _proposalDescription,
    publish: ProposalPublish.submittedProposal,
    versionNumber: 1,
    duration: 6,
    updateDate: DateTime.now(),
  ),
  ProposalBrief(
    selfRef: SignedDocumentRef.generateFirstRef(),
    title: 'Proposal Title that rocks the world',
    categoryName: 'Cardano Use Cases / MVP',
    author: 'Alex Wells',
    fundsRequested: const Coin.fromWholeAda(100000),
    commentsCount: 0,
    description: _proposalDescription,
    publish: ProposalPublish.submittedProposal,
    versionNumber: 1,
    duration: 6,
    updateDate: DateTime.now(),
  ),
  ProposalBrief(
    selfRef: SignedDocumentRef.generateFirstRef(),
    title: 'Proposal Title that rocks the world',
    categoryName: 'Cardano Use Cases / MVP',
    author: 'Alex Wells',
    fundsRequested: const Coin.fromWholeAda(100000),
    commentsCount: 0,
    description: _proposalDescription,
    publish: ProposalPublish.submittedProposal,
    versionNumber: 1,
    duration: 6,
    updateDate: DateTime.now(),
  ),
];

void _onFavoriteChanged(ProposalBrief proposal, bool isFavorite) {
  final proposals = Set.of(_favoriteProposals.value);
  if (isFavorite) {
    proposals.add(proposal);
  } else {
    proposals.remove(proposal);
  }
  _favoriteProposals.value = proposals.toList();
}

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

class _AllProposals extends StatelessWidget {
  const _AllProposals();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ProposalBrief>>(
      valueListenable: _favoriteProposals,
      builder: (context, favoriteProposals, child) {
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (final proposal in _proposals)
              ProposalBriefCard(
                proposal: proposal,
                isFavorite: favoriteProposals.contains(proposal),
                onFavoriteChanged: (isFavorite) => _onFavoriteChanged(proposal, isFavorite),
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
    return ValueListenableBuilder<List<ProposalBrief>>(
      valueListenable: _favoriteProposals,
      builder: (context, favoriteProposals, child) {
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (final proposal in favoriteProposals)
              ProposalBriefCard(
                proposal: proposal,
                isFavorite: true,
                onFavoriteChanged: (isFavorite) => _onFavoriteChanged(proposal, isFavorite),
              ),
          ],
        );
      },
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
            if (state.isActive) const _UnlockedHeaderActions(),
          ],
        );
      },
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
          VoicesTabBar(
            tabs: [
              VoicesTab(
                data: 'all',
                child: VoicesTabText(context.l10n.noOfAll(_proposals.length)),
              ),
              VoicesTab(
                data: 'favorites',
                child: Row(
                  children: [
                    VoicesAssets.icons.starOutlined.buildIcon(),
                    const SizedBox(width: 8),
                    VoicesTabText(context.l10n.favorites),
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
              suffixIcon: VoicesAssets.icons.arrowTriangleDown.buildIcon(size: 16),
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
