import 'package:catalyst_voices/common/ext/ext.dart';
import 'package:catalyst_voices/common/formatters/amount_formatter.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class CurrentCampaign extends StatelessWidget {
  const CurrentCampaign({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 120, top: 64, right: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const _Header(),
          const SizedBox(height: 32),
          const _CurrentCampaignDetails(),
          const SizedBox(height: 80),
          const _SubTitle(),
          _CampaignTimeline(mockCampaignTimeline),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 568),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.l10n.currentCampaign,
            style: context.textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.catalystF14,
            style: context.textTheme.displayMedium?.copyWith(
              color: context.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            context.l10n.currentCampaignDescription,
            style: context.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class _CurrentCampaignDetails extends StatelessWidget {
  const _CurrentCampaignDetails();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: context.voicesColors.elevationsOnSurfaceNeutralLv2,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: context.voicesColors.outlineBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          VoicesAssets.icons.library.buildIcon(),
          const SizedBox(height: 32),
          const Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CampaignFundsDetail(
                title: 'Campaign Treasury',
                description: 'Total budget, including ecosystem incentives',
                funds: 50000000,
              ),
              _CampaignFundsDetail(
                title: 'Current Total Ask',
                description: 'Funds requested by all submitted projects',
                funds: 4020000,
                largeFundsText: false,
              ),
              _RangeAsk(range: Range(min: 1500000, max: 30000)),
            ],
          ),
        ],
      ),
    );
  }
}

class _CampaignFundsDetail extends StatelessWidget {
  final String title;
  final String description;
  final int funds;
  final bool largeFundsText;
  const _CampaignFundsDetail({
    required this.title,
    required this.description,
    required this.funds,
    this.largeFundsText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: context.textTheme.titleMedium?.copyWith(
              color: context.voicesColors.textOnPrimaryLevel1,
            ),
          ),
          Text(
            description,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.voicesColors.textDisabled,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '${const Currency.ada().symbol} $_formattedFunds',
            style: _foundsTextStyle(context)?.copyWith(
              color: context.voicesColors.textOnPrimaryLevel1,
            ),
          ),
        ],
      ),
    );
  }

  String get _formattedFunds => AmountFormatter.decimalFormat(funds);

  TextStyle? _foundsTextStyle(BuildContext context) {
    if (largeFundsText) {
      return context.textTheme.headlineLarge;
    } else {
      return context.textTheme.headlineSmall;
    }
  }
}

class _RangeAsk extends StatelessWidget {
  final Range<int> range;
  const _RangeAsk({
    required this.range,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: context.voicesColors.outlineBorder,
              width: 1,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _RangeValue(
              title: 'Maximum Ask',
              value: range.max ?? 0,
            ),
            const SizedBox(height: 19),
            _RangeValue(
              title: 'Minimum Ask',
              value: range.min ?? 0,
            ),
          ],
        ),
      ),
    );
  }
}

class _RangeValue extends StatelessWidget {
  final String title;
  final int value;
  const _RangeValue({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(title),
        Text('${const Currency.ada().symbol} $_formattedValue'),
      ],
    );
  }

  String get _formattedValue => AmountFormatter.decimalFormat(value);
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 592),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Idea Journey',
            style: context.textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'Ideas comes to life in Catalyst through its key stages below. For the full timeline, deadlines and latest updates, visit the fund timeline Gitbook page.',
            style: context.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class _CampaignTimeline extends StatelessWidget {
  final List<CampaignTimeline> timelineItem;
  const _CampaignTimeline(this.timelineItem);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 209,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: timelineItem.length,
        itemBuilder: (context, index) => _CampaignTimelineCard(
          timelineItem[index],
        ),
        // prototypeItem: _CampaignTimelineCard(CampaignTimeline.dummy()),
        itemExtent: 288,
      ),
    );
  }
}

class _CampaignTimelineCard extends StatelessWidget {
  final CampaignTimeline timelineItem;
  const _CampaignTimelineCard(this.timelineItem);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                VoicesAssets.icons.calendar.buildIcon(),
                VoicesAssets.icons.chevronRight.buildIcon(),
              ],
            ),
            Text(
              timelineItem.title,
              style: context.textTheme.titleMedium,
            ),
            Text(
              '${timelineItem.timeline.from?.year}-${timelineItem.timeline.to?.year}',
            ),
            const SizedBox(height: 8),
            Text(
              timelineItem.description,
              style: context.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
