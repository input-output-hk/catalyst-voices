import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/voting/widgets/header/voting_category_picker.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class VotingCategoryHeader extends StatelessWidget {
  final CampaignCategoryDetailsViewModel category;

  const VotingCategoryHeader({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 32),
      child: Stack(
        children: [
          Positioned.fill(
            child: _Background(image: category.image),
          ),
          Padding(
            padding: const EdgeInsets.all(28),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 24,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VoicesAssets.icons.viewGrid.buildIcon(
                        size: 32,
                        color: context.colors.iconsForeground,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        category.formattedName,
                        style: context.textTheme.displaySmall,
                      ),
                      const SizedBox(height: 48),
                      Text(
                        context.l10n.description,
                        style: context.textTheme.titleSmall?.copyWith(
                          color: context.colors.textOnPrimaryLevel1,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        category.shortDescription,
                        style: context.textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
                const VotingCategoryPickerSelector(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Background extends StatelessWidget {
  final SvgGenImage image;

  const _Background({
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: context.colors.cardBackgroundGradient,
        ),
      ),
      child: image.buildIcon(),
    );
  }
}
