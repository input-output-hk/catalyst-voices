import 'package:catalyst_voices/widgets/images/voices_image_scheme.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String? title;
  final String? description;
  final Widget? image;
  final Widget? imageBackground;

  const EmptyState({
    super.key,
    this.title,
    this.description,
    this.image,
    this.imageBackground,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          image ??
              VoicesImagesScheme(
                image: CatalystSvgPicture.asset(
                  VoicesAssets.images.noProposalForeground.path,
                ),
                background: imageBackground ??
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: theme.colors.onSurfaceNeutral08,
                        shape: BoxShape.circle,
                      ),
                    ),
              ),
          const SizedBox(height: 24),
          SizedBox(
            width: 430,
            child: Column(
              children: [
                Text(
                  _buildTitle(context),
                  style: textTheme.titleMedium
                      ?.copyWith(color: theme.colors.textOnPrimaryLevel1),
                ),
                const SizedBox(height: 8),
                Text(
                  _buildDescription(context),
                  style: textTheme.bodyMedium
                      ?.copyWith(color: theme.colors.textOnPrimaryLevel1),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _buildDescription(BuildContext context) {
    return description ?? context.l10n.noProposalStateDescription;
  }

  String _buildTitle(BuildContext context) {
    return title ?? context.l10n.noProposalStateTitle;
  }
}
