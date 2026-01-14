import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/discovery/sections/most_recent_proposals/widgets/most_recent_proposals_scrollable_list.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class RecentProposals extends StatelessWidget {
  const RecentProposals({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _Background(
      constraints: const BoxConstraints.tightFor(
        height: 800,
        width: double.infinity,
      ),
      child: ResponsivePadding(
        xs: const EdgeInsets.symmetric(horizontal: 48),
        sm: const EdgeInsets.symmetric(horizontal: 48),
        md: const EdgeInsets.symmetric(horizontal: 100),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 72),
            _ProposalsTitle(),
            SizedBox(height: 48),
            MostRecentProposalsScrollableList(),
            SizedBox(height: 16),
            _ViewAllProposalsButton(),
            SizedBox(height: 72),
          ],
        ),
      ),
    );
  }
}

class _Background extends StatelessWidget {
  final Widget child;
  final BoxConstraints constraints;

  const _Background({
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

class _ProposalsTitle extends StatelessWidget {
  const _ProposalsTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      key: const Key('MostRecentProposalsTitle'),
      context.l10n.mostRecent,
      style: context.textTheme.headlineLarge?.copyWith(
        color: context.colors.discoveryTextOnPrimaryWhite,
      ),
    );
  }
}

class _ViewAllProposalsButton extends StatelessWidget {
  const _ViewAllProposalsButton();

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: context.colors.discoveryOnPrimary,
        foregroundColor: context.colors.discoveryPrimary,
      ),
      child: Text(
        key: const Key('ViewAllProposalsBtn'),
        context.l10n.viewAllProposals,
      ),
      onTap: () => const ProposalsRoute().go(context),
    );
  }
}
