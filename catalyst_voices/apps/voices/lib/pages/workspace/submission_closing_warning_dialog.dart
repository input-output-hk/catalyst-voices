import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/cards/tip_card.dart';
import 'package:catalyst_voices/widgets/countdown/voices_countdown.dart';
import 'package:catalyst_voices/widgets/text/proposal_submission_closes_text.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class SubmissionClosingWarningDialog extends StatelessWidget {
  final DateTime submissionCloseAt;
  final ValueChanged<bool>? dontShowAgain;

  const SubmissionClosingWarningDialog({
    super.key,
    required this.submissionCloseAt,
    this.dontShowAgain,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesTwoPaneDialog(
      left: _LeftSide(dontShowAgain),
      right: _RightSide(submissionCloseAt),
      leftPadding: EdgeInsets.zero,
    );
  }

  static Future<void> show({
    required BuildContext context,
    ValueChanged<bool>? dontShowAgain,
    required DateTime submissionCloseAt,
  }) async {
    await VoicesDialog.show<void>(
      context: context,
      builder: (context) => SubmissionClosingWarningDialog(
        submissionCloseAt: submissionCloseAt,
        dontShowAgain: dontShowAgain,
      ),
      routeSettings: const RouteSettings(name: '/submission-closing-warning'),
    );
  }

  static Future<void> showNDaysBefore({
    required BuildContext context,
    ValueChanged<bool>? dontShowAgain,
    required DateTime submissionCloseAt,
    int nDays = 3,
  }) async {
    final now = DateTime.now();
    final threeDaysBefore = submissionCloseAt.subtract(Duration(days: nDays));
    if (now.isAfter(threeDaysBefore) && now.isBefore(submissionCloseAt)) {
      await VoicesDialog.show<void>(
        context: context,
        builder: (context) => SubmissionClosingWarningDialog(
          submissionCloseAt: submissionCloseAt,
          dontShowAgain: dontShowAgain,
        ),
        routeSettings: const RouteSettings(name: '/submission-closing-warning'),
      );
    }
  }
}

class _Countdown extends StatelessWidget {
  final DateTime date;

  const _Countdown({
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesCountdown(
      dateTime: date,
      builder: (context, days, hours, minutes, seconds) => Text(
        context.l10n.catalystAppClosesIn(
          days,
          hours,
          minutes,
          seconds,
        ),
        style: context.textTheme.titleMedium?.copyWith(
          color: context.colorScheme.primary,
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.headsUp,
      style: context.textTheme.displayMedium?.copyWith(
        color: context.colorScheme.primary,
      ),
    );
  }
}

class _HeadsUpInfo extends StatelessWidget {
  final String text;
  final bool isBold;

  const _HeadsUpInfo(
    this.text, {
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text.bullet(),
      style: context.textTheme.bodyLarge?.copyWith(
        color: context.colors.textOnPrimaryLevel1,
        fontWeight: isBold ? FontWeight.w700 : null,
      ),
    );
  }
}

class _LeftSide extends StatefulWidget {
  final ValueChanged<bool>? dontShowAgain;

  const _LeftSide(this.dontShowAgain);

  @override
  State<_LeftSide> createState() => _LeftSideState();
}

class _LeftSideState extends State<_LeftSide> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CatalystImage.asset(
          VoicesAssets.images.headsUp.path,
          fit: BoxFit.cover,
        ),
        Positioned(
          bottom: 20,
          left: 20,
          child: CheckboxTheme(
            data: Theme.of(context).checkboxTheme.copyWith(
                  side: BorderSide(
                    color: context.colorScheme.primary,
                    width: 2,
                  ),
                ),
            child: VoicesCheckbox(
              value: isChecked,
              onChanged: _handleCheckboxChange,
              label: Text(
                context.l10n.dontShowAgain,
                style: context.textTheme.bodyLarge?.copyWith(
                  color: context.colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleCheckboxChange(bool value) {
    setState(() {
      isChecked = value;
    });
    widget.dontShowAgain?.call(value);
  }
}

class _RightSide extends StatelessWidget {
  final DateTime date;

  const _RightSide(this.date);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(),
        const _Header(),
        const SizedBox(height: 12),
        ProposalSubmissionClosesText(dateTime: date),
        const SizedBox(height: 12),
        _HeadsUpInfo(context.l10n.submitProposalBeforeClosing),
        _HeadsUpInfo(context.l10n.checkMaxProposal),
        _HeadsUpInfo(
          context.l10n.catalystAppNotAvailableAfterSubmissionCloses,
          isBold: true,
        ),
        const Spacer(),
        _Countdown(date: date),
        const SizedBox(height: 10),
        TipCard(
          headerText: context.l10n.wantToBackUpProposals,
          tips: [
            context.l10n.goMyProposals,
            context.l10n.exportProposalsIndividually,
            context.l10n.storeInSafeLocation,
          ],
        ),
      ],
    );
  }
}
