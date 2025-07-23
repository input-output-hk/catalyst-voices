import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/common/formatters/date_formatter.dart';
import 'package:catalyst_voices/widgets/countdown/animated_voices_countdown.dart';
import 'package:catalyst_voices/widgets/text/timezone_date_time_text.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class CampaignPhaseCountdown extends StatelessWidget {
  final CampaignPhaseCountdownViewModel phaseCountdown;
  final ValueChanged<bool>? onCountdownEnd;

  const CampaignPhaseCountdown({
    super.key,
    required this.phaseCountdown,
    this.onCountdownEnd,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 32,
      children: [
        _CampaignPhaseTitleText(phaseCountdown),
        AnimatedVoicesCountdown(
          dateTime: phaseCountdown.date,
          onCountdownEnd: onCountdownEnd,
        ),
      ],
    );
  }
}

class _CampaignPhaseTitleText extends StatelessWidget {
  final CampaignPhaseCountdownViewModel phaseCountdown;

  const _CampaignPhaseTitleText(this.phaseCountdown);

  @override
  Widget build(BuildContext context) {
    return TimezoneDateTimeText(
      phaseCountdown.date,
      style: context.textTheme.titleLarge,
      formatter: (context, dateTime) {
        final date = DateFormatter.formatDateTimeParts(dateTime, includeYear: true);
        final dateAtTime = context.l10n.dateAtTime(date.date, date.time);
        return phaseCountdown.title(context.l10n, dateAtTime);
      },
    );
  }
}
