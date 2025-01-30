import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/routes/routing/spaces_route.dart';
import 'package:catalyst_voices/widgets/cards/funds_detail_card.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class LeftSide extends StatelessWidget {
  final String categoryId;

  const LeftSide({
    super.key,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 112),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _BackButton(),
          const SizedBox(height: 32),
          const _CategoryBrief(
            categoryName: 'Cardano Use Cases: Concept',
            categoryDescription:
                '''Cardano Use Cases: Concept will accept early stage ideas to deliver proof of concept, design research and basic prototyping through to MVP for innovative Cardano-based products, services, and business models.''',
          ),
          const SizedBox(height: 64),
          const FundsDetailCard(
            allFunds: 500000,
            totalAsk: 100000,
            askRange: Range(min: 15000, max: 100000),
            type: FundsDetailCardType.category,
          ),
          const SizedBox(height: 48),
          ExpansionPanelList(
            elevation: 0,
            children: [
              ExpansionPanel(
                isExpanded: true,
                headerBuilder: (context, isExpanded) => const Text('Header'),
                body: const Text('LONG TEXT'),
                backgroundColor: Colors.transparent,
              ),
              ExpansionPanel(
                isExpanded: true,
                headerBuilder: (context, isExpanded) => const Text('Header'),
                body: const Text('LONG TEXT'),
                backgroundColor: Colors.transparent,
              ),
              ExpansionPanel(
                isExpanded: true,
                headerBuilder: (context, isExpanded) => const Text('Header'),
                body: const Text('LONG TEXT'),
                backgroundColor: Colors.transparent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context) {
    return VoicesTextButton(
      leading: VoicesAssets.icons.arrowLeft.buildIcon(
        color: context.colors.textOnPrimaryLevel1,
      ),
      child: Text(
        context.l10n.backToCampaign,
        style: context.textTheme.labelLarge?.copyWith(
          color: context.colors.textOnPrimaryLevel1,
        ),
      ),
      onTap: () {
        const DiscoveryRoute().go(context);
      },
    );
  }
}

class _CategoryBrief extends StatelessWidget {
  final String categoryName;
  final String categoryDescription;
  const _CategoryBrief({
    required this.categoryName,
    required this.categoryDescription,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 580),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.l10n.category,
            style: context.textTheme.titleSmall?.copyWith(
              color: context.colors.textOnPrimaryLevel1,
            ),
          ),
          Text(
            categoryName,
            style: context.textTheme.displaySmall,
          ),
          const SizedBox(height: 16),
          Text(
            categoryDescription,
            style: context.textTheme.bodyMedium,
          ),
          const SizedBox(height: 35),
          VoicesOutlinedButton(
            child: Text(
              context.l10n.exploreCategories,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
