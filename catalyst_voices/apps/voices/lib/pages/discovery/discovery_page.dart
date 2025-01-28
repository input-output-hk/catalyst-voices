import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/discovery/how_it_works.dart';
import 'package:catalyst_voices/pages/discovery/state_selectors/current_campaign_selector.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_outlined_button.dart';
import 'package:catalyst_voices/widgets/cards/campaign_category_card.dart';
import 'package:catalyst_voices/widgets/cards/pending_proposal_card.dart';
import 'package:catalyst_voices/widgets/heroes/section_hero.dart';
import 'package:catalyst_voices/widgets/scrollbar/voices_slider.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({super.key});

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {
  @override
  void initState() {
    super.initState();

    unawaited(context.read<DiscoveryCubit>().getAllData());
  }

  @override
  Widget build(BuildContext context) {
    return const CustomScrollView(
      slivers: [
        _Body(),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionCubit, SessionState, bool>(
      selector: (state) => state.account?.isProposer ?? false,
      builder: (context, state) {
        return _GuestVisitorBody(
          isProposer: state,
        );
      },
    );
  }
}

class _GuestVisitorBody extends StatelessWidget {
  final bool isProposer;

  const _GuestVisitorBody({required this.isProposer});

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate(
            [
              _CampaignHeroSection(
                isProposer: isProposer,
              ),
              const HowItWorks(),
              const CurrentCampaignSelector(),
              _CampaignCategories(
                List.filled(
                  6,
                  CampaignCategoryCardViewModel.dummy(),
                ),
              ),
              _LatestProposals(
                proposals: List.filled(
                  7,
                  PendingProposal.dummy(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CampaignHeroSection extends StatelessWidget {
  final bool isProposer;
  const _CampaignHeroSection({required this.isProposer});

  @override
  Widget build(BuildContext context) {
    return HeroSection(
      asset: VoicesAssets.videos.heroDesktop,
      assetPackageName: 'catalyst_voices_assets',
      child: Padding(
        padding: const EdgeInsets.only(
          left: 120,
          bottom: 64,
          top: 32,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 450,
          ),
          child: _CampaignBrief(
            isProposer: isProposer,
          ),
        ),
      ),
    );
  }
}

class _CampaignBrief extends StatelessWidget {
  final bool isProposer;
  const _CampaignBrief({required this.isProposer});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.heroSectionTitle,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 32),
        Text(
          context.l10n.projectCatalystDescription,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            VoicesFilledButton(
              onTap: () {
                // TODO(LynxxLynx): implement redirect to current campaign
              },
              child: Text(context.l10n.viewProposals),
            ),
            const SizedBox(width: 8),
            Offstage(
              offstage: !isProposer,
              child: VoicesOutlinedButton(
                onTap: () {
                  // TODO(LynxxLynx): implement redirect to my proposals
                },
                child: Text(context.l10n.myProposals),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CampaignCategories extends StatelessWidget {
  final List<CampaignCategoryCardViewModel> categories;

  const _CampaignCategories(this.categories);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 120),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.campaignCategories,
            style: context.textTheme.titleLarge,
          ),
          const SizedBox(height: 24),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 1480,
            ),
            child: GridView.builder(
              scrollDirection: Axis.vertical,
              physics: const ClampingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 390,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                mainAxisExtent: 651,
              ),
              itemBuilder: (context, index) {
                final category = categories[index];
                return CampaignCategoryCard(
                  key: Key('CampaignCategoryCard${category.id}'),
                  category: category,
                );
              },
              itemCount: categories.length,
            ),
          ),
        ],
      ),
    );
  }
}

class _LatestProposals extends StatefulWidget {
  final List<PendingProposal> proposals;
  final bool isLoading;

  const _LatestProposals({
    required this.proposals,
    this.isLoading = false,
  });

  @override
  State<_LatestProposals> createState() => _LatestProposalsState();
}

class _LatestProposalsState extends State<_LatestProposals>
    with TickerProviderStateMixin {
  late final ScrollController _scrollController;
  late double _scrollPercentage;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _scrollPercentage = 0.0;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 900),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CatalystImage.asset(
            VoicesAssets.images.campaignHero.path,
          ).image,
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 72),
          Text(
            context.l10n.mostRecent,
            style: context.textTheme.headlineLarge?.copyWith(
              color: context.colors.textOnPrimaryWhite,
            ),
          ),
          const SizedBox(height: 48),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onHorizontalDragUpdate: _onHorizontalDrag,
              child: SizedBox(
                height: 440,
                child: ListView.separated(
                  controller: _scrollController,
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 120),
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.proposals.length,
                  itemBuilder: (context, index) {
                    final proposal = widget.proposals[index];
                    return Skeletonizer(
                      enabled: widget.isLoading,
                      child: PendingProposalCard(
                        key: Key('PendingProposalCard_${proposal.id}'),
                        proposal: proposal,
                        onFavoriteChanged: (value) {},
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 24),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: VoicesSlider(
              value: _scrollPercentage,
              onChanged: _onSliderChanged,
            ),
          ),
          const SizedBox(height: 16),
          VoicesFilledButton(
            backgroundColor: context.colorScheme.onPrimary,
            foregroundColor: context.colorScheme.primary,
            child: Text(
              context.l10n.viewAllProposals,
            ),
            onTap: () {},
          ),
          const SizedBox(height: 72),
        ],
      ),
    );
  }

  void _onHorizontalDrag(DragUpdateDetails details) {
    final offset = _scrollController.offset - details.delta.dx;
    final overMax = offset > _scrollController.position.maxScrollExtent;

    if (offset < 0 || overMax) {
      return;
    }
    _scrollController.jumpTo(
      _scrollController.offset - details.delta.dx,
    );
  }

  void _onScroll() {
    final scrollPosition = _scrollController.position.pixels;
    final maxScroll = _scrollController.position.maxScrollExtent;
    setState(() {
      _scrollPercentage = scrollPosition / maxScroll;
    });
  }

  void _onSliderChanged(double value) {
    final maxScroll = _scrollController.position.maxScrollExtent;
    _scrollController.jumpTo(maxScroll * value);
  }
}
