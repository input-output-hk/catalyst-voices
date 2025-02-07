import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/routes/routes.dart';
import 'package:catalyst_voices/widgets/cards/voices_leading_icon_card.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class CategoryProposalsDetailsCard extends StatelessWidget {
  final String categoryId;
  final String categoryName;
  final int categoryProposalsCount;

  const CategoryProposalsDetailsCard({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.categoryProposalsCount,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesLeadingIconCard(
      icon: VoicesAssets.icons.globeAlt,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.proposalsSubmittedCount(categoryProposalsCount),
            style: context.textTheme.titleMedium?.copyWith(
              color: context.colors.textOnPrimaryLevel0,
            ),
          ),
          Text(
            context.l10n.inObject(categoryName),
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colors.textOnPrimaryLevel1,
            ),
          ),
          const SizedBox(height: 16),
          VoicesOutlinedButton(
            child: Text(context.l10n.viewProposals),
            onTap: () {
              ProposalsRoute(categoryId: categoryId).go(context);
            },
          ),
        ],
      ),
    );
  }
}
