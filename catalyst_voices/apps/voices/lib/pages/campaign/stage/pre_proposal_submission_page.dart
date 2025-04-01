import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/campaign/stage/background.dart';
import 'package:catalyst_voices/routes/routing/spaces_route.dart';
import 'package:catalyst_voices/widgets/cards/countdown_value_card.dart';
import 'package:catalyst_voices/widgets/countdown/voices_countdown.dart';
import 'package:catalyst_voices/widgets/text/proposal_submission_start_text.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreProposalSubmissionPage extends StatelessWidget {
  final DateTime? startDate;

  const PreProposalSubmissionPage({super.key, this.startDate});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeBuilder.buildTheme(),
      child: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const _Header(),
            if (startDate != null) ...[
              const SizedBox(height: 32),
              ProposalSubmissionStartText(startDate: startDate!),
              const SizedBox(height: 32),
              VoicesCountdown(
                dateTime: startDate!,
                onCountdownEnd: (value) => _onCountdownEnd(value, context),
                builder: (context, days, hours, minutes, seconds) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CountDownValueCard(
                      value: days,
                      unit: context.l10n.days,
                    ),
                    CountDownValueCard(
                      value: hours,
                      unit: context.l10n.hours,
                    ),
                    CountDownValueCard(
                      value: minutes,
                      unit: context.l10n.minutes,
                    ),
                    CountDownValueCard(
                      value: seconds,
                      unit: context.l10n.seconds,
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 48),
            const _Description(),
            const SizedBox(height: 24),
            const _ActionButton(),
          ],
        ),
      ),
    );
  }

  void _onCountdownEnd(bool isEnd, BuildContext context) {
    if (isEnd) {
      context.read<CampaignStageCubit>().proposalSubmissionStarted();
      const DiscoveryRoute().pushReplacement(context);
    }
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton();

  @override
  Widget build(BuildContext context) {
    return VoicesFilledButton(
      onTap: () {
        // TODO(LynxLynxx): implement url launching
      },
      child: Text(context.l10n.learnMore),
    );
  }
}

class _Description extends StatelessWidget {
  const _Description();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.preSubmitProposalStageDescription,
      textAlign: TextAlign.center,
      style: context.textTheme.bodyLarge,
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.catalystF14,
      style: context.textTheme.displaySmall?.copyWith(
        color: context.colorScheme.primary,
      ),
    );
  }
}
