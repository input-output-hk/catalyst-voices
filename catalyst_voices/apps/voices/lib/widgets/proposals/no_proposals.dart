import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class NoProposals extends StatelessWidget {
  final String? title;
  final String? description;
  const NoProposals({
    super.key,
    this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 64),
        child: Column(
          children: [
            CatalystSvgPicture.asset(
              _buildImage(theme).path,
              height: 180,
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
      ),
    );
  }

  SvgGenImage _buildImage(ThemeData theme) {
    return switch (theme.brightness) {
      Brightness.light => VoicesAssets.images.proposalEmptyState,
      Brightness.dark => VoicesAssets.images.proposalEmptyStateDark,
    };
  }

  String _buildTitle(BuildContext context) {
    return title ?? context.l10n.noProposalStateTitle;
  }

  String _buildDescription(BuildContext context) {
    return description ?? context.l10n.noProposalStateDescription;
  }
}
