import 'dart:async';

import 'package:catalyst_voices/common/constants/constants.dart';
import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/cards/tip_card.dart';
import 'package:catalyst_voices/widgets/countdown/voices_countdown.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

class ProposalLimitReachedDialog extends StatelessWidget {
  final int currentSubmissions;
  final int maxSubmissions;
  final DateTime submissionCloseAt;
  final ValueChanged<bool>? dontShowAgain;

  const ProposalLimitReachedDialog({
    super.key,
    required this.currentSubmissions,
    required this.maxSubmissions,
    required this.submissionCloseAt,
    this.dontShowAgain,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesTwoPaneDialog(
      left: _LeftSide(dontShowAgain),
      right: _RightSide(
        currentSubmissions: currentSubmissions,
        maxSubmissions: maxSubmissions,
        date: submissionCloseAt,
      ),
      leftPadding: EdgeInsets.zero,
    );
  }

  static Future<void> show({
    required BuildContext context,
    required int currentSubmissions,
    required int maxSubmissions,
    required DateTime submissionCloseAt,
    ValueChanged<bool>? dontShowAgain,
  }) async {
    await VoicesDialog.show<void>(
      context: context,
      builder: (context) => ProposalLimitReachedDialog(
        currentSubmissions: currentSubmissions,
        maxSubmissions: maxSubmissions,
        submissionCloseAt: submissionCloseAt,
        dontShowAgain: dontShowAgain,
      ),
      routeSettings: const RouteSettings(name: '/proposal-limit-reached'),
    );
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
      builder: (
        context, {
        required days,
        required hours,
        required minutes,
        required seconds,
      }) =>
          Text(
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

  const _HeadsUpInfo(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.withBullet(),
      style: context.textTheme.bodyLarge?.copyWith(
        color: context.colors.textOnPrimaryLevel1,
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
          VoicesAssets.images.trafficCone.path,
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

class _RightSide extends StatelessWidget with LaunchUrlMixin {
  final int currentSubmissions;
  final int maxSubmissions;
  final DateTime date;

  const _RightSide({
    required this.currentSubmissions,
    required this.maxSubmissions,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),
        const _Header(),
        const SizedBox(height: 12),
        _Subheader(currentSubmissions: currentSubmissions),
        const SizedBox(height: 12),
        _HeadsUpInfo(context.l10n.proposalsLimitReachedPoint1),
        _HeadsUpInfo(context.l10n.proposalsLimitReachedPoint2(maxSubmissions)),
        _HeadsUpInfo(context.l10n.proposalsLimitReachedPoint3),
        _HeadsUpInfo(context.l10n.proposalsLimitReachedPoint4),
        const SizedBox(height: 32),
        VoicesLearnMoreFilledButton.url(
          url: VoicesConstants.proposalPublishingDocsUrl,
        ),
        const Spacer(),
        _Countdown(date: date),
        const SizedBox(height: 10),
        TipCard(
          headerText: context.l10n.proposalsLimitReachedCaptionTitle,
          tips: [
            context.l10n.proposalsLimitReachedCaptionText,
          ],
        ),
      ],
    );
  }
}

class _Subheader extends StatelessWidget {
  final int currentSubmissions;

  const _Subheader({required this.currentSubmissions});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.proposalsLimitReachedSubtitle(currentSubmissions),
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colors.textOnPrimaryLevel1,
          ),
    );
  }
}
