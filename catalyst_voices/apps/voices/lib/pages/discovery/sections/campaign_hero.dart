import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/routes/routing/spaces_route.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_outlined_button.dart';
import 'package:catalyst_voices/widgets/heroes/section_hero.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class CampaignHeroSection extends StatelessWidget {
  const CampaignHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      key: const Key('CampaignHeroSection'),
      constraints: const BoxConstraints(minHeight: 450),
      child: HeroSection(
        asset: VideoCacheKey(name: VoicesAssets.videos.heroDesktop),
        errorBuilder: (context, error, stackTrace) => CatalystImage.asset(
          VoicesAssets.images.discoveryFallback.path,
          fit: BoxFit.cover,
        ),
        child: ResponsivePadding(
          xs: const EdgeInsets.only(left: 20, bottom: 16, top: 8, right: 20),
          sm: const EdgeInsets.only(left: 80, bottom: 32, top: 18),
          md: const EdgeInsets.only(left: 150, bottom: 64, top: 32),
          lg: const EdgeInsets.only(left: 150, bottom: 64, top: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 450,
            ),
            child: const _CampaignBrief(),
          ),
        ),
      ),
    );
  }
}

class _CampaignBrief extends StatelessWidget {
  const _CampaignBrief();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          key: const Key('CampaignBriefTitle'),
          context.l10n.heroSectionTitle,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: context.colors.discoveryPrimary,
          ),
        ),
        const SizedBox(height: 32),
        Text(
          key: const Key('CampaignBriefDescription'),
          context.l10n.projectCatalystDescription,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: context.colors.discoveryTextOnPrimary,
          ),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            VoicesFilledButton(
              key: const Key('ViewProposalsBtn'),
              onTap: () {
                const ProposalsRoute().go(context);
              },
              style: FilledButton.styleFrom(
                backgroundColor: context.colors.discoveryPrimary,
                foregroundColor: context.colors.discoveryOnPrimary,
              ),
              child: Text(context.l10n.viewProposals),
            ),
            const SizedBox(width: 8),
            const _DiscoveryMyProposalsButton(),
          ],
        ),
      ],
    );
  }
}

class _DiscoveryMyProposalsButton extends StatelessWidget {
  const _DiscoveryMyProposalsButton();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SessionCubit, SessionState, bool>(
      selector: (state) => (state.account?.isProposer ?? false),
      builder: (context, state) {
        return Offstage(
          offstage: !state,
          child: VoicesOutlinedButton(
            onTap: () {
              const WorkspaceRoute().go(context);
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: context.colors.discoveryPrimary,
              foregroundColor: context.colors.discoveryOnPrimary,
            ),
            child: Text(context.l10n.myProposals),
          ),
        );
      },
    );
  }
}
