import 'package:catalyst_voices/common/formatters/date_formatter.dart';
import 'package:catalyst_voices/widgets/buttons/voices_text_button.dart';
import 'package:catalyst_voices/widgets/headers/segment_header.dart';
import 'package:catalyst_voices/widgets/navigation/sections_controller.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class TreasuryCampaignStepHeader extends StatelessWidget {
  final TreasurySectionStep step;

  const TreasuryCampaignStepHeader({
    super.key,
    required this.step,
  });

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

class TreasuryCampaignTimezone extends StatelessWidget {
  const TreasuryCampaignTimezone({super.key});

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
