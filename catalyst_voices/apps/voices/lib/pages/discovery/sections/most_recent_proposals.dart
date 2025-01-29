import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/routes/routing/spaces_route.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/cards/pending_proposal_card.dart';
import 'package:catalyst_voices/widgets/scrollbar/voices_slider.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class MostRecentProposals extends StatefulWidget {
  final List<PendingProposal> proposals;
  final bool isLoading;

  const MostRecentProposals({
    super.key,
    required this.proposals,
    this.isLoading = false,
  });

  @override
  State<MostRecentProposals> createState() => _LatestProposalsState();
}

class _LatestProposalsState extends State<MostRecentProposals>
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
              color: ThemeBuilder.buildTheme().colors.textOnPrimaryWhite,
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
            backgroundColor: ThemeBuilder.buildTheme().colorScheme.onPrimary,
            foregroundColor: ThemeBuilder.buildTheme().colorScheme.primary,
            child: Text(
              context.l10n.viewAllProposals,
            ),
            onTap: () => const ProposalsRoute().go(context),
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
