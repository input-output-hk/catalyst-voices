import 'package:catalyst_voices/pages/treasury/steps/treasury_campaign_widgets.dart';
import 'package:catalyst_voices/widgets/navigation/section_step_state_builder.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TreasuryCampaignStagesEditStep extends StatelessWidget {
  final TreasurySectionStep step;

  const TreasuryCampaignStagesEditStep({
    super.key,
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    return SectionStepStateBuilder(
      id: step.sectionStepId,
      builder: (context, value, child) {
        return WorkspaceTileContainer(
          isSelected: value.isSelected,
          content: Column(
            children: [
              TreasuryCampaignStepHeader(step: step),
              const SizedBox(height: 12),
              const TreasuryCampaignTimezone(),
              const SizedBox(height: 24),
              _DateRange(step: step),
            ],
          ),
        );
      },
    );
  }
}

class _DateRange extends StatefulWidget {
  final TreasurySectionStep step;

  const _DateRange({required this.step});

  @override
  State<_DateRange> createState() => _DateRangeState();
}

class _DateRangeState extends State<_DateRange> {
  final VoicesDateTimeFieldController _startDateController =
      VoicesDateTimeFieldController();

  final VoicesDateTimeFieldController _endDateController =
      VoicesDateTimeFieldController();

  @override
  void initState() {
    super.initState();

    final cubit = context.read<CampaignBuilderCubit>();
    _startDateController.value = cubit.state.startDate;
    _endDateController.value = cubit.state.endDate;
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

                SectionsControllerScope.of(context).editStep(
                  widget.step.sectionStepId,
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
