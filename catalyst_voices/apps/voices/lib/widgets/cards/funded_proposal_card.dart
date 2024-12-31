import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

/// Displays a proposal in funded state on a card.
class FundedProposalCard extends StatelessWidget {
  final AssetGenImage image;
  final FundedProposal proposal;
  final bool isFavorite;
  final ValueChanged<bool>? onFavoriteChanged;

  const FundedProposalCard({
    super.key,
    required this.image,
    required this.proposal,
    this.isFavorite = false,
    this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 326,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(
            image: image,
            isFavorite: isFavorite,
            onFavoriteChanged: onFavoriteChanged,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FundCategory(
                  fund: proposal.campaignName,
                  category: proposal.category,
                ),
                const SizedBox(height: 4),
                _Title(text: proposal.title),
                const SizedBox(height: 4),
                _FundedDate(dateTime: proposal.fundedDate),
                const SizedBox(height: 24),
                _FundsAndComments(
                  funds: proposal.fundsRequested,
                  commentsCount: proposal.commentsCount,
                ),
                const SizedBox(height: 24),
                _Description(text: proposal.description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final AssetGenImage image;
  final bool isFavorite;
  final ValueChanged<bool>? onFavoriteChanged;

  const _Header({
    required this.image,
    required this.isFavorite,
    required this.onFavoriteChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 168,
      child: Stack(
        children: [
          Positioned.fill(
            child: CatalystImage.asset(
              image.path,
              fit: BoxFit.cover,
            ),
          ),
          if (onFavoriteChanged != null)
            Positioned(
              top: 2,
              right: 2,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () => onFavoriteChanged?.call(!isFavorite),
                icon: CatalystSvgIcon.asset(
                  isFavorite
                      ? VoicesAssets.icons.plusCircleFilled.path
                      : VoicesAssets.icons.plusCircleOutlined.path,
                  size: 20,
                  color: Theme.of(context).colors.iconsOnImage,
                ),
              ),
            ),
          Positioned(
            left: 12,
            bottom: 12,
            child: VoicesChip.rectangular(
              padding: const EdgeInsets.fromLTRB(10, 6, 10, 4),
              leading: VoicesAssets.icons.briefcase.buildIcon(
                color: Theme.of(context).colorScheme.primary,
              ),
              content: Text(context.l10n.fundedProposal),
              backgroundColor: Theme.of(context).colors.primary98,
            ),
          ),
        ],
      ),
    );
  }
}

class _FundCategory extends StatelessWidget {
  final String fund;
  final String category;

  const _FundCategory({
    required this.fund,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: '$fund / ',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colors.textDisabled,
            ),
        children: [
          TextSpan(
            text: category,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String text;

  const _Title({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _FundedDate extends StatelessWidget {
  final DateTime dateTime;

  const _FundedDate({required this.dateTime});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.fundedProposalDate(dateTime),
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}

class _FundsAndComments extends StatelessWidget {
  final String funds;
  final int commentsCount;

  const _FundsAndComments({
    required this.funds,
    required this.commentsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colors.success?.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                funds,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                context.l10n.fundsRequested,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          VoicesChip.rectangular(
            padding: const EdgeInsets.fromLTRB(8, 6, 12, 6),
            leading: VoicesAssets.icons.checkCircle.buildIcon(
              color: Theme.of(context).colors.success,
            ),
            content: Text(context.l10n.noOfComments(commentsCount)),
            backgroundColor: Theme.of(context).colors.successContainer,
          ),
        ],
      ),
    );
  }
}

class _Description extends StatelessWidget {
  final String text;

  const _Description({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colors.textOnPrimary,
          ),
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
    );
  }
}
