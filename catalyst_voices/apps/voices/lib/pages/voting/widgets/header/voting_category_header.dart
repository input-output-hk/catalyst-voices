import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/voting/widgets/header/voting_category_picker.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class VotingCategoryHeader extends StatelessWidget {
  final VotingHeaderCategoryData category;

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
            child: _Background(image: CategoryImageUrl.image(category.imageUrl)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 32, 32, 44),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    VoicesAssets.icons.viewGrid.buildIcon(
                      size: 32,
                      color: context.colors.iconsForeground,
                    ),
                    const VotingCategoryPickerSelector(),
                  ],
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
                Align(
                  alignment: Alignment.topLeft,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 628),
                    child: Text(
                      category.description,
                      style: context.textTheme.bodyLarge,
                    ),
                  ),
                ),
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
      child: Stack(
        children: [
          Positioned(
            top: -150,
            right: -80,
            child: Transform.rotate(
              angle: -0.1,
              child: image.buildPicture(
                width: 450,
                fit: BoxFit.fitWidth,
                color: _getImageColor(context).withValues(alpha: 0.1),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getImageColor(BuildContext context) {
    final isLight = context.theme.isLight;
    return isLight ? context.colors.iconsPrimary : Colors.white;
  }
}
