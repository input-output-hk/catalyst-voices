import 'package:catalyst_voices/routes/routing/spaces_route.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_outlined_button.dart';
import 'package:catalyst_voices/widgets/heroes/section_hero.dart';
import 'package:catalyst_voices_assets/generated/assets.gen.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CampaignHeroSection extends StatelessWidget {
  const CampaignHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 450),
      child: HeroSection(
        asset: VoicesAssets.videos.heroDesktop,
        assetPackageName: 'catalyst_voices_assets',
        child: ResponsivePadding(
          xs: const EdgeInsets.only(left: 40, bottom: 16, top: 8, right: 40),
          sm: const EdgeInsets.only(left: 80, bottom: 32, top: 18),
          md: const EdgeInsets.only(left: 150, bottom: 64, top: 32),
          lg: const EdgeInsets.only(left: 150, bottom: 64, top: 32),
          other: const EdgeInsets.only(left: 150, bottom: 64, top: 32),
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
          context.l10n.heroSectionTitle,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: ThemeBuilder.buildTheme().colorScheme.primary,
              ),
        ),
        const SizedBox(height: 32),
        Text(
          context.l10n.projectCatalystDescription,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: ThemeBuilder.buildTheme().colors.textOnPrimaryLevel0,
              ),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            VoicesFilledButton(
              onTap: () {
                const ProposalsRoute().go(context);
              },
              backgroundColor: ThemeBuilder.buildTheme().colorScheme.primary,
              foregroundColor: ThemeBuilder.buildTheme().colorScheme.onPrimary,
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
            foregroundColor: ThemeBuilder.buildTheme().colorScheme.primary,
            child: Text(context.l10n.myProposals),
          ),
        );
      },
    );
  }
}
