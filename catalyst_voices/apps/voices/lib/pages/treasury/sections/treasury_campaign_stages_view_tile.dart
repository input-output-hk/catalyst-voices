import 'package:catalyst_voices/common/formatters/date_formatter.dart';
import 'package:catalyst_voices/pages/treasury/sections/treasury_campaign_widgets.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TreasuryCampaignStagesViewTile extends StatelessWidget {
  final TreasurySection data;

  const TreasuryCampaignStagesViewTile(
    this.data, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SectionStateBuilder(
      id: data.id,
      builder: (context, value, child) {
        return SelectableTile(
          isSelected: value.isSelected,
          child: Column(
            children: [
              TreasuryCampaignStepHeader(data),
              const SizedBox(height: 12),
              const TreasuryCampaignTimezone(),
              const SizedBox(height: 24),
              const _DateRange(),
            ],
          ),
        );
      },
    );
  }
}

class _DateRange extends StatelessWidget {
  const _DateRange();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SegmentHeader(
            name: context.l10n.startAndEndDates,
            padding: EdgeInsets.zero,
          ),
          const SizedBox(height: 12),
          const Row(
            children: [
              _StartDate(),
              SizedBox(width: 24),
              _EndDate(),
            ],
          ),
          const SizedBox(height: 36),
        ],
      ),
    );
  }
}

class _StartDate extends StatelessWidget {
  const _StartDate();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:
          BlocSelector<CampaignBuilderCubit, CampaignBuilderState, DateTime?>(
        selector: (state) => state.startDate,
        builder: (context, date) {
          return _Date(
            label: context.l10n.campaignStart,
            dateTime: date,
          );
        },
      ),
    );
  }
}

class _EndDate extends StatelessWidget {
  const _EndDate();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:
          BlocSelector<CampaignBuilderCubit, CampaignBuilderState, DateTime?>(
        selector: (state) => state.endDate,
        builder: (context, date) {
          return _Date(
            label: context.l10n.campaignEnd,
            dateTime: date,
          );
        },
      ),
    );
  }
}

class _Date extends StatelessWidget {
  final String label;
  final DateTime? dateTime;

  const _Date({
    required this.label,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Text(
          _formatDate(context, dateTime),
          style: theme.textTheme.bodyLarge!.copyWith(
            color: dateTime == null
                ? theme.colors.textDisabled
                : theme.colors.onPrimaryContainer,
          ),
        ),
      ],
    );
  }

  String _formatDate(BuildContext context, DateTime? date) {
    if (date == null) {
      return context.l10n.noDateTimeSelected;
    }

    return DateFormatter.formatFullDateTime(date, timeOnNewline: true);
  }
}
