import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/common/formatters/amount_formatter.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class CampaignCategoryCard extends StatelessWidget {
  final CampaignCategoryCardViewModel category;

  const CampaignCategoryCard({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.colors.elevationsOnSurfaceNeutralLv1White,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.colors.outlineBorderVariant.withOpacity(.38),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      constraints: const BoxConstraints.tightFor(
        width: 390,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // TODO(LynxxLynx): implement image when info from where it comes
          CatalystImage.asset(
            VoicesAssets.images.campaignCategoryDeveloper.path,
            fit: BoxFit.fill,
            height: 220,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _Title(category.name),
                _Title(category.subname),
                const SizedBox(height: 16),
                _CampaignStats(
                  availableFunds: category.availableFunds,
                  proposalsCount: category.proposalsCount,
                ),
                const SizedBox(height: 16),
                _Description(category.description),
                const SizedBox(height: 32),
                _Buttons(
                  categoryId: category.id,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  final String categoryId;

  const _Buttons({
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        VoicesFilledButton(
          onTap: () {
            // TOOD(LynxxLynx): implement redirect to category details
          },
          child: Text(context.l10n.categoryDetails),
        ),
        const SizedBox(height: 8),
        VoicesFilledButton(
          onTap: () {
            // TODO(LynxxLynx): implement redirect to proposals
            //page with category filter
          },
          backgroundColor: context.colors.elevationsOnSurfaceNeutralLv2,
          foregroundColor: context.colorScheme.primary,
          child: Text(context.l10n.viewProposals),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  final String text;

  const _Title(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: context.textTheme.titleLarge,
    );
  }
}

class _Description extends StatelessWidget {
  final String description;

  const _Description(this.description);

  @override
  Widget build(BuildContext context) {
    return Text(
      description,
      style: context.textTheme.bodyMedium?.copyWith(
        color: context.colors.textOnPrimaryLevel1,
      ),
      maxLines: 5,
    );
  }
}

class _CampaignStats extends StatelessWidget {
  final int availableFunds;
  final int proposalsCount;

  const _CampaignStats({
    required this.availableFunds,
    required this.proposalsCount,
  });

  String get _availableFundsText {
    // ignore: lines_longer_than_80_chars
    return '${const Currency.ada().symbol} ${AmountFormatter.decimalFormat(availableFunds)}';
  }

  String get _proposalsCountText {
    return '$proposalsCount';
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.onSurfacePrimary08,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            _TextStats(
              text: context.l10n.fundsAvailable,
              value: _availableFundsText,
            ),
            const Spacer(),
            SizedBox(
              height: 48,
              child: VerticalDivider(
                thickness: 1,
                color: context.colors.onSurfacePrimary016,
              ),
            ),
            const SizedBox(width: 16),
            _TextStats(
              text: context.l10n.proposals,
              value: _proposalsCountText,
            ),
          ],
        ),
      ),
    );
  }
}

class _TextStats extends StatelessWidget {
  final String text;
  final String value;

  const _TextStats({
    required this.text,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colors.textOnPrimaryLevel1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: context.textTheme.titleLarge?.copyWith(
            color: context.colors.textOnPrimaryLevel1,
          ),
        ),
      ],
    );
  }
}
