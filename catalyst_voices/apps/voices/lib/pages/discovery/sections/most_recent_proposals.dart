import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/cards/pending_proposal_card.dart';
import 'package:catalyst_voices/widgets/scrollbar/voices_slider.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class ViewAllProposals extends StatelessWidget {
  const ViewAllProposals({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Background(
      key: Key('MostRecentViewAllProposals'),
      constraints: BoxConstraints(maxHeight: 184),
      child: Center(
        child: _ViewAllProposalsButton(),
      ),
    );
  }
}

class _Background extends StatelessWidget {
  final Widget child;
  final BoxConstraints constraints;

  const _Background({
    super.key,
    required this.child,
    this.constraints = const BoxConstraints(maxHeight: 900),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('MostRecentProposals'),
      constraints: constraints,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CatalystImage.asset(
            VoicesAssets.images.campaignHero.path,
          ).image,
          fit: BoxFit.cover,
        ),
      ),
      child: child,
    );
  }
}

class _LatestProposalsState extends State<MostRecentProposals> {
  late final ScrollController _scrollController;
  late double _scrollPercentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('MostRecentProposals'),
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
            key: const Key('MostRecentProposalsTitle'),
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
                child: Center(
                  child: ListView.separated(
                    controller: _scrollController,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 120),
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.proposals.length,
                    itemBuilder: (context, index) {
                      final proposal = widget.proposals[index];
                      final ref = proposal.ref;
                      return Skeletonizer(
                        enabled: widget.isLoading,
                        child: PendingProposalCard(
                          key: Key('PendingProposalCard_$ref'),
                          proposal: proposal,
                          onTap: () {
                            unawaited(
                              ProposalRoute(
                                proposalId: ref.id,
                                version: ref.version,
                              ).push(context),
                            );
                          },
                          onFavoriteChanged: (value) async {
                            final bloc = context.read<DiscoveryCubit>();
                            if (value) {
                              await bloc.addFavorite(ref);
                            } else {
                              await bloc.removeFavorite(ref);
                            }
                          },
                          isFavorite: proposal.isFavorite,
                        ),
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 24),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: VoicesSlider(
              key: const Key('MostRecentProposalsSlider'),
              value: _scrollPercentage,
              onChanged: _onSliderChanged,
            ),
          ),
          const SizedBox(height: 16),
          const _ViewAllProposalsButton(),
          const SizedBox(height: 72),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _scrollPercentage = 0.0;
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

class _ViewAllProposalsButton extends StatelessWidget {
  const _ViewAllProposalsButton();

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      backgroundColor: ThemeBuilder.buildTheme().colorScheme.onPrimary,
      foregroundColor: ThemeBuilder.buildTheme().colorScheme.primary,
      child: Text(
        key: const Key('ViewAllProposalsBtn'),
        context.l10n.viewAllProposals,
      ),
      onTap: () => const ProposalsRoute().go(context),
    );
  }
}
