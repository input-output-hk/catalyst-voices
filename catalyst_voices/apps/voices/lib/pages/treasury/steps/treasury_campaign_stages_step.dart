import 'package:catalyst_voices/common/formatters/date_formatter.dart';
import 'package:catalyst_voices/widgets/navigation/section_step_state_builder.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TreasuryCampaignStagesStep extends StatelessWidget {
  final TreasurySectionStep step;

  const TreasuryCampaignStagesStep({
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
              _Header(step: step),
              const SizedBox(height: 12),
              const _Timezone(),
              const SizedBox(height: 24),
              _DateRange(step: step),
            ],
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final TreasurySectionStep step;

  const _Header({required this.step});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SegmentHeader(
        name: step.localizedDesc(context),
        actions: [
          ValueListenableBuilder(
            valueListenable: SectionsControllerScope.of(context),
            builder: (context, sectionsState, child) {
              final isEditing = sectionsState.isEditing(step.sectionStepId);

              return VoicesTextButton(
                onTap: step.isEditable
                    ? () => _onToggleEditing(context, !isEditing)
                    : null,
                child: Text(
                  isEditing
                      ? context.l10n.cancelButtonText
                      : context.l10n.stepEdit,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _onToggleEditing(BuildContext context, bool isEditing) {
    SectionsControllerScope.of(context).editStep(
      step.sectionStepId,
      enabled: isEditing,
    );
  }
}

class _Timezone extends StatelessWidget {
  const _Timezone();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.setupCampaignStagesTimezone,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          const _TimezoneValue(),
        ],
      ),
    );
  }
}

class _TimezoneValue extends StatelessWidget {
  const _TimezoneValue();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colors.elevationsOnSurfaceNeutralLv1Grey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          VoicesAssets.icons.globeAlt.buildIcon(size: 20),
          const SizedBox(width: 8),
          Text(
            _formatTimezone(),
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }

  String _formatTimezone() {
    return DateFormatter.formatTimezone(DateTimeExt.now());
  }
}

class _DateRange extends StatelessWidget {
  final TreasurySectionStep step;

  const _DateRange({required this.step});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: SectionsControllerScope.of(context),
      builder: (context, sectionsState, child) {
        final isEditing = sectionsState.isEditing(step.sectionStepId);
        return isEditing ? _EditDateRange(step: step) : const _ViewDateRange();
      },
    );
  }
}

class _ViewDateRange extends StatelessWidget {
  const _ViewDateRange();

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
              _ViewStartDate(),
              SizedBox(width: 24),
              _ViewEndDate(),
            ],
          ),
          const SizedBox(height: 36),
        ],
      ),
    );
  }
}

class _EditDateRange extends StatefulWidget {
  final TreasurySectionStep step;

  const _EditDateRange({required this.step});

  @override
  State<_EditDateRange> createState() => _EditDateRangeState();
}

class _EditDateRangeState extends State<_EditDateRange> {
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

class _ViewStartDate extends StatelessWidget {
  const _ViewStartDate();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:
          BlocSelector<CampaignBuilderCubit, CampaignBuilderState, DateTime?>(
        selector: (state) => state.startDate,
        builder: (context, date) {
          return _ViewDate(
            label: context.l10n.campaignStart,
            dateTime: date,
          );
        },
      ),
    );
  }
}

class _ViewEndDate extends StatelessWidget {
  const _ViewEndDate();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:
          BlocSelector<CampaignBuilderCubit, CampaignBuilderState, DateTime?>(
        selector: (state) => state.endDate,
        builder: (context, date) {
          return _ViewDate(
            label: context.l10n.campaignEnd,
            dateTime: date,
          );
        },
      ),
    );
  }
}

class _ViewDate extends StatelessWidget {
  final String label;
  final DateTime? dateTime;

  const _ViewDate({
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
