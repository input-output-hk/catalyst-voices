import 'package:catalyst_voices/common/formatters/date_formatter.dart';
import 'package:catalyst_voices/widgets/tiles/voices_expansion_tile.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class CampaignDetailsTile extends StatelessWidget {
  final String description;
  final DateTime publishDate;
  final DateTime startDate;
  final DateTime endDate;
  final int categoriesCount;
  final int proposalsCount;

  const CampaignDetailsTile({
    super.key,
    required this.description,
    required this.publishDate,
    required this.startDate,
    required this.endDate,
    required this.categoriesCount,
    required this.proposalsCount,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesExpansionTile(
      initiallyExpanded: true,
      title: Text(context.l10n.campaignDetails),
      children: [
        _Body(
          description: description,
        ),
        const SizedBox(height: 16 + 24),
        _CampaignData(
          publishDate: publishDate,
          startDate: startDate,
          endDate: endDate,
          categoriesCount: categoriesCount,
          proposalsCount: proposalsCount,
        ),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final String description;

  const _Body({
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colors = theme.colors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleSmall?.copyWith(
            color: colors.textOnPrimaryLevel1,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          description,
          style: textTheme.bodyLarge?.copyWith(
            color: colors.textOnPrimaryLevel1,
          ),
        ),
      ],
    );
  }
}

class _CampaignData extends StatelessWidget {
  final DateTime publishDate;
  final DateTime startDate;
  final DateTime endDate;
  final int categoriesCount;
  final int proposalsCount;

  const _CampaignData({
    required this.publishDate,
    required this.startDate,
    required this.endDate,
    required this.categoriesCount,
    required this.proposalsCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colors;
    final l10n = context.l10n;

    return Container(
      decoration: BoxDecoration(
        color: colors.onSurfacePrimary012,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          _CampaignDataTile(
            key: const ValueKey('StartDateTileKey'),
            title: l10n.startDate,
            subtitle: DateFormatter.formatInDays(l10n, startDate),
            value: startDate.day,
            valueSuffix: DateFormatter.formatShortMonth(l10n, startDate),
          ),
          _CampaignDataTile(
            key: const ValueKey('EndDateTileKey'),
            title: l10n.endDate,
            subtitle: DateFormatter.formatInDays(l10n, endDate),
            value: endDate.day,
            valueSuffix: DateFormatter.formatShortMonth(l10n, endDate),
          ),
          _CampaignDataTile(
            key: const ValueKey('CategoriesTileKey'),
            title: l10n.categories,
            subtitle: DateFormatter.formatInDays(
              l10n,
              DateTime.now(),
              from: publishDate,
            ),
            value: categoriesCount,
          ),
          _CampaignDataTile(
            key: const ValueKey('ProposalsTileKey'),
            title: l10n.proposals,
            subtitle: l10n.totalSubmitted,
            value: proposalsCount,
          ),
        ]
            .map<Widget>((e) => Expanded(child: e))
            .separatedBy(const SizedBox(width: 16))
            .toList(),
      ),
    );
  }
}

class _CampaignDataTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final int value;
  final String? valueSuffix;

  const _CampaignDataTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    this.valueSuffix,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colors = theme.colors;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: textTheme.titleSmall?.copyWith(
            color: colors.textOnPrimaryLevel1,
          ),
        ),
        Text(
          subtitle,
          style: textTheme.bodySmall?.copyWith(
            // TODO(damian-molinski): This color does not have property.
            // Colors/sys color neutral md ref/N60
            color: const Color(0xFF7F90B3),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          textBaseline: TextBaseline.alphabetic,
          crossAxisAlignment: valueSuffix != null
              ? CrossAxisAlignment.baseline
              : CrossAxisAlignment.end,
          children: [
            Text(
              '$value',
              style: textTheme.headlineLarge?.copyWith(
                color: colors.textOnPrimaryLevel1,
              ),
            ),
            if (valueSuffix != null) ...[
              const SizedBox(width: 4),
              Text(
                valueSuffix!,
                style: textTheme.titleMedium?.copyWith(
                  color: colors.textOnPrimaryLevel1,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
