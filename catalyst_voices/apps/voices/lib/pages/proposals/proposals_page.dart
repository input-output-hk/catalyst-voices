import 'dart:async';

import 'package:catalyst_voices/pages/campaign/details/campaign_details_dialog.dart';
import 'package:catalyst_voices/widgets/cards/campaign_stage_card.dart';
import 'package:catalyst_voices/widgets/cards/proposal_card.dart';
import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices/widgets/common/tab_bar_stack_view.dart';
import 'package:catalyst_voices/widgets/empty_state/empty_state.dart';
import 'package:catalyst_voices/widgets/indicators/voices_circular_progress_indicator.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProposalsPage extends StatefulWidget {
  final String? categoryId;
  const ProposalsPage({
    super.key,
    this.categoryId,
  });

  @override
  State<ProposalsPage> createState() => _ProposalsPageState();
}

class _ProposalsPageState extends State<ProposalsPage> {
  @override
  void initState() {
    super.initState();
    unawaited(context.read<ProposalsCubit>().load());
    unawaited(context.read<CampaignInfoCubit>().load());
  }

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        _ActiveAccountBody(),
      ],
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
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _FundInfo()),
            Expanded(child: _CampaignStage()),
          ],
        ),
      ],
    );
  }
}

class _FundInfo extends StatelessWidget {
  const _FundInfo();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 680),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.discoverySpaceTitle,
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.discoverySpaceDescription,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const _CampaignDetailsButton(),
        ],
      ),
    );
  }
}

class _CampaignDetailsButton extends StatelessWidget {
  const _CampaignDetailsButton();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<CampaignInfoCubit, CampaignInfoState, String?>(
      selector: (state) => state.campaign?.id,
      builder: (context, campaignId) {
        return Offstage(
          offstage: campaignId == null,
          child: Padding(
            padding: const EdgeInsets.only(top: 32),
            child: OutlinedButton.icon(
              onPressed: () {
                if (campaignId == null) {
                  throw ArgumentError('Campaign ID is null');
                }
                unawaited(
                  CampaignDetailsDialog.show(context, id: campaignId),
                );
              },
              label: Text(context.l10n.campaignDetails),
              icon: VoicesAssets.icons.arrowsExpand.buildIcon(),
            ),
          ),
        );
      },
    );
  }
}

class _CampaignStage extends StatelessWidget {
  const _CampaignStage();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: BlocBuilder<CampaignInfoCubit, CampaignInfoState>(
          builder: (context, state) {
            final campaign = state.campaign;
            return campaign != null
                ? CampaignStageCard(campaign: campaign)
                : const Offstage();
          },
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
              child: AffixDecorator(
                gap: 8,
                prefix: VoicesAssets.icons.starOutlined.buildIcon(),
                child: Text(context.l10n.favorites),
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
          LoadedProposalsState(:final proposals) => proposals.isEmpty
              ? const _EmptyProposals()
              : _AllProposalsList(
                  proposals: proposals,
                ),
        };
      },
    );
  }
}

class _AllProposalsList extends StatelessWidget {
  final List<ProposalViewModel> proposals;

  const _AllProposalsList({
    required this.proposals,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        for (final proposal in proposals)
          ProposalCard(
            image: _generateImageForProposal(proposal.id),
            proposal: proposal,
            showStatus: false,
            showLastUpdate: false,
            showComments: false,
            showSegments: false,
            isFavorite: proposal.isFavorite,
            onFavoriteChanged: (isFavorite) async {
              await context.read<ProposalsCubit>().onChangeFavoriteProposal(
                    proposal.id,
                    isFavorite: isFavorite,
                  );
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
          LoadedProposalsState(:final proposals) => proposals.favorites.isEmpty
              ? const _EmptyProposals()
              : _FavoriteProposalsList(
                  proposals: proposals.favorites,
                ),
        };
      },
    );
  }
}

class _FavoriteProposalsList extends StatelessWidget {
  final List<ProposalViewModel> proposals;

  const _FavoriteProposalsList({required this.proposals});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        for (final proposal in proposals)
          ProposalCard(
            image: _generateImageForProposal(proposal.id),
            proposal: proposal,
            showStatus: false,
            showLastUpdate: false,
            showComments: false,
            showSegments: false,
            isFavorite: true,
            onFavoriteChanged: (isFavorite) async {
              await context.read<ProposalsCubit>().onChangeFavoriteProposal(
                    proposal.id,
                    isFavorite: isFavorite,
                  );
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
    return Center(
      child: EmptyState(
        description: context.l10n.discoverySpaceEmptyProposals,
      ),
    );
  }
}

AssetGenImage _generateImageForProposal(String id) {
  return id.codeUnits.last.isEven
      ? VoicesAssets.images.proposalBackground1
      : VoicesAssets.images.proposalBackground2;
}
