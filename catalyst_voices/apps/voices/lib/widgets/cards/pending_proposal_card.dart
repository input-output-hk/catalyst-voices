import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices/common/formatters/date_formatter.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

/// Displays a proposal in pending state on a card.
class PendingProposalCard extends StatelessWidget {
  final AssetGenImage image;
  final PendingProposal proposal;
  final bool showStatus;
  final bool showLastUpdate;
  final bool showComments;
  final bool showSegments;
  final bool isFavorite;
  final ValueChanged<bool>? onFavoriteChanged;

  const PendingProposalCard({
    super.key,
    required this.image,
    required this.proposal,
    this.showStatus = true,
    this.showLastUpdate = true,
    this.showComments = true,
    this.showSegments = true,
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
            showStatus: showStatus,
            isFavorite: isFavorite,
            onFavoriteChanged: onFavoriteChanged,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FundCategory(
                  fund: proposal.fund,
                  category: proposal.category,
                ),
                const SizedBox(height: 4),
                _Title(text: proposal.title),
                if (showLastUpdate) ...[
                  const SizedBox(height: 4),
                  _LastUpdateDate(dateTime: proposal.lastUpdateDate),
                ],
                const SizedBox(height: 24),
                _FundsAndComments(
                  funds: proposal.fundsRequested,
                  commentsCount: proposal.commentsCount,
                  showComments: showComments,
                ),
                const SizedBox(height: 24),
                _Description(text: proposal.description),
              ],
            ),
          ),
          if (showSegments)
            _CompletedSegments(
              completed: proposal.completedSegments,
              total: proposal.totalSegments,
            ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final AssetGenImage image;
  final bool showStatus;
  final bool isFavorite;
  final ValueChanged<bool>? onFavoriteChanged;

  const _Header({
    required this.image,
    required this.showStatus,
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
                      ? VoicesAssets.icons.starFilled.path
                      : VoicesAssets.icons.starOutlined.path,
                  size: 20,
                  color: Theme.of(context).colors.iconsOnImage,
                ),
              ),
            ),
          if (showStatus)
            Positioned(
              left: 12,
              bottom: 12,
              child: VoicesChip.rectangular(
                padding: const EdgeInsets.fromLTRB(10, 6, 10, 4),
                leading: VoicesAssets.icons.briefcase.buildIcon(
                  color: Theme.of(context).colorScheme.primary,
                ),
                content: Text(context.l10n.publishedProposal),
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

class _LastUpdateDate extends StatelessWidget {
  final DateTime dateTime;

  const _LastUpdateDate({required this.dateTime});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.lastUpdateDate(
        DateFormatter.formatRecentDate(context.l10n, dateTime),
      ),
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}

class _FundsAndComments extends StatelessWidget {
  final Coin funds;
  final int commentsCount;
  final bool showComments;

  const _FundsAndComments({
    required this.funds,
    required this.commentsCount,
    required this.showComments,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                CryptocurrencyFormatter.formatAmount(funds),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Text(
                context.l10n.fundsRequested,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          if (showComments)
            VoicesChip.rectangular(
              padding: const EdgeInsets.fromLTRB(8, 6, 12, 6),
              leading: VoicesAssets.icons.checkCircle.buildIcon(
                color: Theme.of(context).colorScheme.primary,
              ),
              content: Text(
                context.l10n.noOfComments(commentsCount),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              backgroundColor:
                  Theme.of(context).colors.onSurfaceNeutralOpaqueLv1,
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

class _CompletedSegments extends StatelessWidget {
  final int completed;
  final int total;

  const _CompletedSegments({
    required this.completed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.primary.withOpacity(0.12),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          VoicesAssets.icons.clipboardCheck.buildIcon(
            size: 18,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              context.l10n.noOfSegmentsCompleted(
                completed,
                total,
                (completed / total * 100).round(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
