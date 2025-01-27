import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/discovery/current_campaign.dart';
import 'package:catalyst_voices/pages/discovery/how_it_works.dart';
import 'package:catalyst_voices/widgets/buttons/voices_filled_button.dart';
import 'package:catalyst_voices/widgets/buttons/voices_outlined_button.dart';
import 'package:catalyst_voices/widgets/cards/campaign_category_card.dart';
import 'package:catalyst_voices/widgets/heroes/section_hero.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DiscoveryPage extends StatelessWidget {
  const DiscoveryPage({super.key});

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
        SliverPadding(
          padding: const EdgeInsets.only(bottom: 32),
          sliver: SliverList(
            delegate: SliverChildListDelegate(
              [
                const _CampaignHeroSection(),
                const HowItWorks(),
                CurrentCampaign(
                  currentCampaignInfo: CurrentCampaignInfoViewModel.dummy(),
                ),
                _CampaignCategories(
                  List.filled(
                    6,
                    CampaignCategoryCardViewModel.dummy(),
                  ),
                ),
                const _LatestProposals(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CampaignHeroSection extends StatelessWidget {
  const _CampaignHeroSection();

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
          child: const _CampaignBrief(),
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
              child: Text(context.l10n.viewCurrentCampaign),
            ),
            const SizedBox(width: 8),
            Offstage(
              offstage: true,
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

class _LatestProposals extends StatelessWidget {
  const _LatestProposals();

  @override
  Widget build(BuildContext context) {
    return const Placeholder(
      color: Colors.blueGrey,
      child: Text('Latest Proposals'),
    );
  }
}
