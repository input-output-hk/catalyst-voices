import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/routes/routing/spaces_route.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class CampaignCategoryCard extends StatelessWidget {
  final CampaignCategoryDetailsViewModel category;

  const CampaignCategoryCard({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('CampaignCategories'),
      decoration: BoxDecoration(
        color: context.colors.elevationsOnSurfaceNeutralLv1White,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.colors.outlineBorderVariant.withValues(alpha: .38),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      constraints: const BoxConstraints.tightFor(
        width: 590,
        height: 631,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _Background(image: category.image),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Title(category.name, const Key('CategoryTitle')),
                  _Title(category.subname, const Key('CategorySubname')),
                  const SizedBox(height: 16),
                  _CampaignStats(
                    availableFunds: category.availableFundsText,
                    finalProposalsCount: category.finalProposalsCount,
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    fit: FlexFit.tight,
                    child: _Description(
                      category.description,
                      key: const Key('Description'),
                    ),
                  ),
                  _Buttons(
                    categoryRef: category.ref,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Background extends StatelessWidget {
  final SvgGenImage image;

  const _Background({required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 590,
      height: 220,
      decoration: BoxDecoration(
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
          Positioned(
            left: 20,
            top: 20,
            child: image.buildPicture(
              width: 280,
              fit: BoxFit.fitWidth,
              color: _getImageColor(context),
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

class _Buttons extends StatelessWidget {
  final SignedDocumentRef categoryRef;

  const _Buttons({
    required this.categoryRef,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        VoicesFilledButton(
          key: const Key('CategoryDetailsBtn'),
          onTap: () {
            CategoryDetailRoute.fromRef(categoryRef: categoryRef).go(context);
          },
          child: Text(context.l10n.categoryDetails),
        ),
        const SizedBox(height: 8),
        VoicesFilledButton(
          key: const Key('ViewProposalsBtn'),
          onTap: () {
            final route = ProposalsRoute.fromRef(categoryRef: categoryRef);
            unawaited(route.push(context));
          },
          style: FilledButton.styleFrom(
            backgroundColor: context.colors.elevationsOnSurfaceNeutralLv2,
            foregroundColor: context.colorScheme.primary,
          ),
          child: Text(context.l10n.viewProposals),
        ),
      ],
    );
  }
}

class _CampaignStats extends StatelessWidget {
  final String availableFunds;
  final int finalProposalsCount;

  const _CampaignStats({
    required this.availableFunds,
    required this.finalProposalsCount,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colors.onSurfacePrimary08,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SizedBox(
          width: double.infinity,
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: [
              _TextStats(
                key: const Key('AvailableFunds'),
                text: context.l10n.fundsAvailable,
                value: availableFunds,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 48,
                    child: VerticalDivider(
                      thickness: 1,
                      color: context.colors.onSurfacePrimary016,
                    ),
                  ),
                  const SizedBox(width: 16),
                  _TextStats(
                    key: const Key('ProposalsCount'),
                    text: context.l10n.proposals,
                    value: finalProposalsCount.toString(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Description extends StatelessWidget {
  final String description;

  const _Description(this.description, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      key: super.key,
      description,
      style: context.textTheme.bodyMedium?.copyWith(
        color: context.colors.textOnPrimaryLevel1,
      ),
      maxLines: 5,
    );
  }
}

class _TextStats extends StatelessWidget {
  final String text;
  final String value;

  const _TextStats({
    required this.text,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          key: const Key('DataTitle'),
          text,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.colors.textOnPrimaryLevel1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          key: const Key('DataValue'),
          value,
          style: context.textTheme.titleLarge?.copyWith(
            color: context.colors.textOnPrimaryLevel1,
          ),
        ),
      ],
    );
  }
}

class _Title extends StatelessWidget {
  final String text;

  const _Title(this.text, [Key? key]) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      key: super.key,
      text,
      style: context.textTheme.titleLarge,
    );
  }
}
