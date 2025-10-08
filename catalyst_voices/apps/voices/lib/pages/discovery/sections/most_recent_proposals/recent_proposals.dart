import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/scrollbar/voices_slider.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class RecentProposals extends StatelessWidget {
  final List<ProposalBrief> proposals;

  const RecentProposals({
    super.key,
    required this.proposals,
  });

  @override
  Widget build(BuildContext context) {
    return _Background(
      constraints: const BoxConstraints.tightFor(
        height: 800,
        width: double.infinity,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 72),
            const _ProposalsTitle(),
            const SizedBox(height: 48),
            _ProposalsScrollableList(proposals: proposals),
            const SizedBox(height: 16),
            const _ViewAllProposalsButton(),
            const SizedBox(height: 72),
          ],
        ),
      ),
    );
  }
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
      key: const Key('RecentProposals'),
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

class _ProposalsList extends StatelessWidget {
  final ScrollController scrollController;
  final List<ProposalBrief> proposals;

  const _ProposalsList({
    required this.scrollController,
    required this.proposals,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      physics: const ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemCount: proposals.length,
      itemBuilder: (context, index) {
        final proposal = proposals[index];
        final ref = proposal.selfRef;
        return Padding(
          key: Key('PendingProposalCard_$ref'),
          padding: EdgeInsets.only(right: index < proposals.length - 1 ? 12 : 0),
          child: ProposalBriefCard(
            proposal: proposal,
            onTap: () => _onCardTap(context, ref),
            onFavoriteChanged: (value) => _onCardFavoriteChanged(context, ref, value),
          ),
        );
      },
      prototypeItem: Padding(
        padding: const EdgeInsets.only(right: 12),
        child: ProposalBriefCard(proposal: ProposalBrief.prototype()),
      ),
    );
  }

  Future<void> _onCardFavoriteChanged(
    BuildContext context,
    DocumentRef ref,
    bool isFavorite,
  ) async {
    final bloc = context.read<DiscoveryCubit>();
    if (isFavorite) {
      await bloc.addFavorite(ref);
    } else {
      await bloc.removeFavorite(ref);
    }
  }

  void _onCardTap(BuildContext context, DocumentRef ref) {
    unawaited(
      ProposalRoute(
        proposalId: ref.id,
        version: ref.version,
      ).push(context),
    );
  }
}

class _ProposalsScrollableList extends StatefulWidget {
  final List<ProposalBrief> proposals;

  const _ProposalsScrollableList({required this.proposals});

  @override
  State<_ProposalsScrollableList> createState() => _ProposalsScrollableListState();
}

class _ProposalsScrollableListState extends State<_ProposalsScrollableList> {
  late final ScrollController _scrollController;
  final ValueNotifier<double> _scrollPercentageNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        VoicesGestureDetector(
          onHorizontalDragUpdate: _onHorizontalDrag,
          child: SizedBox(
            height: 440,
            width: 1200,
            child: Center(
              child: _ProposalsList(
                scrollController: _scrollController,
                proposals: widget.proposals,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: ValueListenableBuilder<double>(
            valueListenable: _scrollPercentageNotifier,
            builder: (context, value, child) {
              return VoicesSlider(
                key: const Key('MostRecentProposalsSlider'),
                value: value,
                onChanged: _onSliderChanged,
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollPercentageNotifier.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onHorizontalDrag(DragUpdateDetails details) {
    final offset = _scrollController.offset - details.delta.dx;
    final overMax = offset > _scrollController.position.maxScrollExtent;

    if (offset < 0 || overMax) return;

    _scrollController.jumpTo(offset);
  }

  void _onScroll() {
    final scrollPosition = _scrollController.position.pixels;
    final maxScroll = _scrollController.position.maxScrollExtent;

    if (maxScroll > 0) {
      _scrollPercentageNotifier.value = scrollPosition / maxScroll;
    }
  }

  void _onSliderChanged(double value) {
    final maxScroll = _scrollController.position.maxScrollExtent;
    unawaited(
      _scrollController.animateTo(
        maxScroll * value,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      ),
    );
  }
}

class _ProposalsTitle extends StatelessWidget {
  const _ProposalsTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      key: const Key('MostRecentProposalsTitle'),
      context.l10n.mostRecent,
      style: context.textTheme.headlineLarge?.copyWith(
        color: ThemeBuilder.buildTheme().colors.textOnPrimaryWhite,
      ),
    );
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
