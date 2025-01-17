import 'package:catalyst_voices/pages/treasury/sections/treasury_campaign_widgets.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TreasuryCampaignStagesEditTile extends StatelessWidget {
  final TreasurySection data;

  const TreasuryCampaignStagesEditTile(
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
              _DateRange(data: data),
            ],
          ),
        );
      },
    );
  }
}

class _DateRange extends StatefulWidget {
  final TreasurySection data;

  const _DateRange({required this.data});

  @override
  State<_DateRange> createState() => _DateRangeState();
}

class _DateRangeState extends State<_DateRange> {
  late final VoicesDateTimeFieldController _startDateController;
  late final VoicesDateTimeFieldController _endDateController;

  @override
  void initState() {
    super.initState();

    final cubit = context.read<CampaignBuilderCubit>();
    _startDateController = VoicesDateTimeFieldController(cubit.state.startDate);
    _endDateController = VoicesDateTimeFieldController(cubit.state.endDate);
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SegmentHeader(
            name: context.l10n.campaignDates,
            padding: EdgeInsets.zero,
          ),
          _EditDate(
            controller: _startDateController,
            label: context.l10n.campaignStart,
            onEdit: _onEditStartDate,
          ),
          const SizedBox(height: 32),
          _EditDate(
            controller: _endDateController,
            label: context.l10n.campaignEnd,
            onEdit: _onEditEndDate,
          ),
          const SizedBox(height: 36),
          Align(
            alignment: Alignment.topRight,
            child: VoicesFilledButton(
              child: Text(context.l10n.saveButtonText),
              onTap: () {
                context.read<CampaignBuilderCubit>().updateCampaignDates(
                      startDate: _startDateController.value,
                      endDate: _endDateController.value,
                    );

                SegmentsControllerScope.of(context).editSection(
                  widget.data.id,
                  enabled: false,
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ignore: use_setters_to_change_properties
  void _onEditStartDate(DateTime? startDate) {
    _startDateController.value = startDate;
  }

  // ignore: use_setters_to_change_properties
  void _onEditEndDate(DateTime? endDate) {
    _endDateController.value = endDate;
  }
}

class _EditDate extends StatelessWidget {
  final String label;
  final VoicesDateTimeFieldController controller;
  final ValueChanged<DateTime?> onEdit;

  const _EditDate({
    required this.controller,
    required this.label,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Flexible(
          child: SizedBox(
            width: 220,
            child: Text(
              label,
              style: theme.textTheme.titleSmall,
            ),
          ),
        ),
        Flexible(
          child: VoicesDateTimeField(
            controller: controller,
            onChanged: onEdit,
            onFieldSubmitted: onEdit,
          ),
        ),
      ],
    );
  }
}
